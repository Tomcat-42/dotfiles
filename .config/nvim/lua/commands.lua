local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local command = api.nvim_create_user_command

command("FormatCmd", function(args)
  local text = table.concat(api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false), " ")
  local out, q = {}, nil
  for i = 1, #text do
    local c = text:sub(i, i)
    if c == "'" or c == '"' then
      if q == c then q = nil elseif not q then q = c end
    end
    local rest = text:sub(i)
    local prev = text:sub(i - 1, i - 1)
    if not q and (
          rest:match("^&&") or
          (rest:match("^%-%-[%w]") and prev == " ") or
          (rest:match("^%-[%w]") and not rest:match("^%-%-") and prev == " ")
        ) then
      out[#out + 1] = " \\\n "
    end
    out[#out + 1] = c
  end
  api.nvim_buf_set_lines(0, args.line1 - 1, args.line2, false, vim.split(table.concat(out), "\n"))
end, { range = "%" })

local comment_types = { comment = true, line_comment = true, block_comment = true }

command("DeleteComments", function()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok then return vim.notify("No treesitter parser", vim.log.levels.WARN) end

  local ranges = {}
  local function collect(node)
    if comment_types[node:type()] then
      ranges[#ranges + 1] = { node:range() }
    else
      for child in node:iter_children() do collect(child) end
    end
  end
  collect(parser:parse()[1]:root())
  table.sort(ranges, function(a, b) return a[1] > b[1] or (a[1] == b[1] and a[2] > b[2]) end)

  for _, r in ipairs(ranges) do
    local sr, sc, er, ec = r[1], r[2], r[3], r[4]
    local before = api.nvim_buf_get_lines(0, sr, sr + 1, false)[1]:sub(1, sc)
    local after = api.nvim_buf_get_lines(0, er, er + 1, false)[1]:sub(ec + 1)
    if before:match("^%s*$") and after:match("^%s*$") then
      api.nvim_buf_set_lines(0, sr, er + 1, false, {})
    else
      api.nvim_buf_set_text(0, sr, #before:gsub("%s+$", ""), er, ec, { "" })
    end
  end
end, { desc = "Delete all comments using treesitter" })

local blame_ns = api.nvim_create_namespace("GitBlameVirtText")

command("GitBlame", function(args)
  local bufnr = api.nvim_get_current_buf()
  local filename = api.nvim_buf_get_name(bufnr)
  local tick = api.nvim_buf_get_changedtick(bufnr)

  api.nvim_buf_clear_namespace(bufnr, blame_ns, args.line1 - 1, args.line2)
  vim.system({
    "sh", "-c", [[
      git blame -p -L "$1" "$2" | awk '
        /^([0-9a-f]{40})/ { commit=$1 }
        /^(author) /      { author=substr($0, 8) }
        /^(author-time) / { time=$2 }
        /^(summary) /     { summary=substr($0, 9) }
        /^\t/ { printf "[%s] %s %s | %s\n", substr(commit,1,8), author, strftime("%Y %b %d", time), summary }
      '
    ]], "sh", args.line1 .. "," .. args.line2, filename,
  }, { text = true }, vim.schedule_wrap(function(result)
    if result.code ~= 0 then
      return vim.notify("GitBlame: " .. (result.stderr or "unknown error"), vim.log.levels.WARN)
    end
    if not api.nvim_buf_is_valid(bufnr) or api.nvim_buf_get_changedtick(bufnr) ~= tick then return end

    local prev = ""
    for i, text in ipairs(vim.split(result.stdout, "\n", { trimempty = true })) do
      local display = text == prev and " --" or (" " .. text)
      api.nvim_buf_set_extmark(bufnr, blame_ns, args.line1 - 1 + (i - 1), 0, {
        virt_text = { { display, "Comment" } },
        virt_text_pos = "eol_right_align",
      })
      prev = text
    end
  end))
end, { range = true, desc = "Show git blame virtual text" })

command("GitBlameClear", function()
  api.nvim_buf_clear_namespace(api.nvim_get_current_buf(), blame_ns, 0, -1)
end, {})

command("HexDump", function()
  vim.b.hex_original_ft = vim.bo.filetype
  vim.bo.binary = true
  cmd("%!xxd")
  vim.bo.filetype = "xxd"
end, {})

command("HexRestore", function()
  cmd("%!xxd -r")
  vim.bo.filetype = vim.b.hex_original_ft or "binary"
  vim.b.hex_original_ft = nil
end, {})

command("HexToggle", function()
  cmd(fn.getline(1):match("^%x%x%x%x%x%x%x%x:") and "HexRestore" or "HexDump")
end, {})

local prg_map = { make = "makeprg", lmake = "makeprg", grep = "grepprg", lgrep = "grepprg" }

local function expand_cmd(input)
  local current = fn.expand("%:p")
  local expanded = input:gsub("%%%%:p", current):gsub("%%%%", current):gsub("#", fn.expand("#:p"))
  if not expanded:match("^:") then return expanded end
  local name, args = expanded:sub(2):match("^(%S+)%s*(.*)")
  if name == "!" then return args end
  if prg_map[name] then
    local prg = vim.o[prg_map[name]]
    return prg:find("%$%*") and prg:gsub("%$%*", args) or prg .. " " .. args
  end
  return expanded:sub(2)
end

local last_run_cmd = nil

local function run_in_term(run_cmd, auto_close)
  local efm = vim.o.errorformat
  local prev_win = api.nvim_get_current_win()

  cmd("botright new | resize " .. math.floor(vim.o.lines / 4))
  vim.bo.buftype, vim.bo.bufhidden, vim.bo.swapfile = "nofile", "wipe", false

  local buf = api.nvim_get_current_buf()
  fn.jobstart(run_cmd, {
    term = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if not api.nvim_buf_is_valid(buf) then return end
        local win = fn.bufwinid(buf)

        if auto_close and code == 0 then
          if win ~= -1 then api.nvim_win_close(win, true) end
          return vim.notify("OK: " .. run_cmd, vim.log.levels.INFO)
        end

        fn.setqflist({}, "r")
        local items = fn.getqflist({ efm = efm, lines = api.nvim_buf_get_lines(buf, 0, -1, false) }).items or {}
        if vim.iter(items):any(function(i) return i.valid == 1 end) then
          if win ~= -1 then api.nvim_win_close(win, true) end
          fn.setqflist(items, "r")
          fn.setqflist({}, "a", { title = run_cmd })
          cmd("copen | cfirst")
        else
          pcall(api.nvim_feedkeys, vim.keycode("<C-\\><C-n>"), "n", false)
        end
      end)
    end,
  })

  api.nvim_set_current_win(prev_win)
  vim.keymap.set("n", "q", function() cmd.quit() end, { buffer = buf, silent = true })
end

command("Run", function(opts)
  local run_cmd = opts.args ~= "" and expand_cmd(opts.args) or last_run_cmd
  if not run_cmd then return vim.notify("No command to run", vim.log.levels.WARN) end
  last_run_cmd = run_cmd
  run_in_term(run_cmd, opts.bang)
end, {
  bang = true,
  nargs = "*",
  complete = function(arg_lead)
    if arg_lead:match("^:") then
      return vim.tbl_map(function(v) return ":" .. v end, fn.getcompletion(arg_lead:sub(2), "command"))
    end
    local seen, results = {}, {}
    for _, t in ipairs({ "shellcmd", "file" }) do
      for _, v in ipairs(fn.getcompletion(arg_lead, t)) do
        if not seen[v] then
          seen[v] = true
          results[#results + 1] = v
        end
      end
    end
    return results
  end,
})

local function fuzzy(items, lead)
  return lead == "" and items or fn.matchfuzzy(items, lead)
end

local function rg(args, limit)
  return fn.systemlist("rg --vimgrep --no-heading --smart-case -- " .. args .. " | head -" .. limit)
end

local function parse_vimgrep(lines)
  local items = {}
  for _, line in ipairs(lines) do
    local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
    if file then
      items[#items + 1] = { filename = file, lnum = tonumber(lnum), col = tonumber(col), text = vim.trim(text) }
    end
  end
  return items
end

local function to_qf(title, items)
  if #items == 0 then return print("No results found") end
  fn.setqflist({}, "r", { title = title, items = items })
  cmd.copen()
end

assert(fn.executable("rg") == 1)

_G._findfunc = function(cmdarg, _)
  local fnames = fn.systemlist("rg --files --hidden --color=never --glob='!.git'")
  return cmdarg == "" and fnames or fn.matchfuzzy(fnames, cmdarg)
end
vim.o.findfunc = "v:lua._findfunc"

command("Buffer", function(opts) cmd("buffer " .. opts.args) end, {
  nargs = 1,
  complete = function(lead)
    local names = {}
    for _, b in ipairs(api.nvim_list_bufs()) do
      if vim.bo[b].buflisted and api.nvim_buf_get_name(b) ~= "" then
        names[#names + 1] = fn.fnamemodify(api.nvim_buf_get_name(b), ":~:.")
      end
    end
    return fuzzy(names, lead)
  end,
})

command("H", function(opts) cmd.help(opts.args) end, {
  nargs = 1,
  complete = function(lead) return fn.getcompletion(lead, "help") end,
})

command("Recent", function(opts) cmd.edit(opts.args) end, {
  nargs = 1,
  complete = function(lead)
    local files = {}
    for _, f in ipairs(vim.v.oldfiles) do
      if vim.uv.fs_stat(f) then files[#files + 1] = fn.fnamemodify(f, ":~:.") end
    end
    return fuzzy(files, lead)
  end,
})

command("Cmd", function(opts) cmd(opts.args) end, {
  nargs = 1,
  complete = function(lead) return fn.getcompletion(lead, "command") end,
})

command("Grep", function(opts)
  local items = parse_vimgrep(rg(fn.shellescape(opts.args), 500))
  to_qf("Grep: " .. opts.args, items)
end, { nargs = "+" })

command("LiveGrep", function(opts)
  local file, lnum = opts.args:match("^(.+):(%d+):")
  if file and lnum then
    cmd.edit(file)
    api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
  end
end, {
  nargs = 1,
  complete = function(lead)
    if #lead < 3 then return {} end
    local items = parse_vimgrep(rg(fn.shellescape(lead), 200))
    return vim.tbl_map(function(i) return i.filename .. ":" .. i.lnum .. ": " .. i.text end, items)
  end,
})

command("Symbols", function()
  vim.lsp.buf_request(0, "textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params() },
    function(err, result)
      if err or not result or #result == 0 then
        return vim.notify("No symbols found", vim.log.levels.INFO)
      end
      local items, bufnr = {}, api.nvim_get_current_buf()
      local function flatten(symbols, prefix)
        for _, s in ipairs(symbols) do
          local name = prefix ~= "" and (prefix .. "." .. s.name) or s.name
          local range = s.selectionRange or s.range
          items[#items + 1] = {
            bufnr = bufnr,
            lnum = range.start.line + 1,
            col = range.start.character + 1,
            text = (vim.lsp.protocol.SymbolKind[s.kind] or "?") .. ": " .. name,
          }
          if s.children then flatten(s.children, name) end
        end
      end
      flatten(result, "")
      vim.schedule(function() to_qf("Document Symbols", items) end)
    end)
end, {})

command("WSymbols", function(opts)
  local query = opts.args ~= "" and opts.args or fn.input("Symbol query: ")
  if query == "" then return end
  vim.lsp.buf_request(0, "workspace/symbol", { query = query }, function(err, result)
    if err or not result or #result == 0 then
      return vim.notify("No symbols found", vim.log.levels.INFO)
    end
    local items = {}
    for _, s in ipairs(result) do
      local loc = s.location
      items[#items + 1] = {
        filename = vim.uri_to_fname(loc.uri),
        lnum = loc.range.start.line + 1,
        col = loc.range.start.character + 1,
        text = (vim.lsp.protocol.SymbolKind[s.kind] or "?") .. ": " .. s.name,
      }
    end
    vim.schedule(function() to_qf("Workspace Symbols: " .. query, items) end)
  end)
end, { nargs = "?" })

command("Bin", function(opts) cmd("Run " .. opts.args) end, {
  nargs = 1,
  complete = function(lead)
    local exes = fn.systemlist("find . -type f -executable -not -path '*/.git/*' 2>/dev/null | head -100")
    return fuzzy(exes, lead)
  end,
})

command("Keymaps", function() end, {
  nargs = 1,
  complete = function(lead)
    local lines = vim.split(api.nvim_exec2("map", { output = true }).output, "\n", { trimempty = true })
    return fuzzy(lines, lead)
  end,
})

local todo_keywords = { "TODO", "FIXME", "HACK", "XXX", "BUG", "WARN" }
local todo_comment_types = { comment = true, line_comment = true, block_comment = true }

command("Todo", function(args)
  local file = api.nvim_buf_get_name(0)
  local scoped = args.range > 0 and file ~= ""
  local scope = scoped and (args.range == 2 and "selection" or "file") or "project"

  if scope == "project" then
    local lines = {}
    fn.jobstart({ "rg", "--vimgrep", "-e", [[\b(TODO|FIXME|HACK|XXX|BUG|WARN)\b]] }, {
      stdin = "null",
      stdout_buffered = true,
      on_stdout = function(_, data) lines = data end,
      on_exit = function(_, code)
        vim.schedule(function()
          if code ~= 0 and code ~= 1 then
            return vim.notify("Todo: rg failed (exit " .. code .. ")", vim.log.levels.WARN)
          end
          local items = {}
          for _, line in ipairs(lines) do
            local f, l, c, t = line:match("^(.+):(%d+):(%d+):(.*)$")
            if f then
              items[#items + 1] = { filename = f, lnum = tonumber(l), col = tonumber(c), text = t }
            end
          end
          if #items == 0 then return print("No TODOs found") end
          fn.setqflist({}, "r", { title = "TODOs (project)", items = items })
          cmd.copen()
        end)
      end,
    })
    return
  end

  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok then return vim.notify("No treesitter parser", vim.log.levels.WARN) end

  local items = {}
  local function collect(node)
    if todo_comment_types[node:type()] then
      local sr = node:range()
      for i, line in ipairs(vim.split(vim.treesitter.get_node_text(node, 0), "\n")) do
        for _, kw in ipairs(todo_keywords) do
          if line:find(kw, 1, true) then
            local lnum = sr + i
            if scope ~= "selection" or (lnum >= args.line1 and lnum <= args.line2) then
              items[#items + 1] = { filename = file, lnum = lnum, col = 1, text = vim.trim(line) }
            end
            break
          end
        end
      end
    else
      for child in node:iter_children() do collect(child) end
    end
  end
  collect(parser:parse()[1]:root())

  if #items == 0 then return print("No TODOs found") end
  fn.setqflist({}, "r", { title = "TODOs (" .. scope .. ")", items = items })
  cmd.copen()
end, { range = true })
