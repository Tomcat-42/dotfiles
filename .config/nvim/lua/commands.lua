local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

-- FormatCmd: break long shell commands into readable multi-line form
cmd([[command! -range=% FormatCmd <line1>,<line2>s/&&/\\\r\&\&/ge|s/--/\\\r --/ge|s/ -\(\w\)/ \\\r -\1/ge]])

-- DeleteComments: remove all comments using treesitter
api.nvim_create_user_command("DeleteComments", function()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok then return vim.notify("No treesitter parser", vim.log.levels.WARN) end

  local comment_types = { comment = true, line_comment = true, block_comment = true }
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
    local sr, sc, er, ec = table.unpack(r)
    local before = api.nvim_buf_get_lines(0, sr, sr + 1, false)[1]:sub(1, sc)
    local after = api.nvim_buf_get_lines(0, er, er + 1, false)[1]:sub(ec + 1)

    if before:match("^%s*$") and after:match("^%s*$") then
      api.nvim_buf_set_lines(0, sr, er + 1, false, {})
    else
      api.nvim_buf_set_text(0, sr, #before:gsub("%s+$", ""), er, ec, { "" })
    end
  end
end, { desc = "Delete all comments using treesitter" })

-- GitBlame: show blame as virtual text
local blame_ns = api.nvim_create_namespace("GitBlameVirtText")

api.nvim_create_user_command("GitBlame", function(args)
  local bufnr = api.nvim_get_current_buf()
  local filename = api.nvim_buf_get_name(bufnr)
  local tick = api.nvim_buf_get_changedtick(bufnr)

  api.nvim_buf_clear_namespace(bufnr, blame_ns, 0, -1)
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
    if not api.nvim_buf_is_valid(bufnr) then return end
    if api.nvim_buf_get_changedtick(bufnr) ~= tick then
      return vim.notify("GitBlame: buffer changed, blame discarded", vim.log.levels.INFO)
    end

    local blame_lines = vim.split(result.stdout, "\n", { trimempty = true })
    local prev = ""
    for i, text in ipairs(blame_lines) do
      local display = (text == prev) and " --" or (" " .. text)
      api.nvim_buf_set_extmark(bufnr, blame_ns, args.line1 - 1 + (i - 1), 0, {
        virt_text = { { display, "Comment" } },
        virt_text_pos = "eol_right_align",
      })
      prev = text
    end
  end))
end, { range = true, desc = "Show git blame virtual text" })

api.nvim_create_user_command("GitBlameClear", function()
  api.nvim_buf_clear_namespace(api.nvim_get_current_buf(), blame_ns, 0, -1)
end, { desc = "Clear git blame virtual text" })

-- Hex: toggle hex dump view
api.nvim_create_user_command("HexDump", function()
  vim.b.hex_original_ft = vim.bo.filetype
  vim.bo.binary = true
  cmd("%!xxd")
  vim.bo.filetype = "xxd"
end, { desc = "Convert buffer to hex dump" })

api.nvim_create_user_command("HexRestore", function()
  cmd("%!xxd -r")
  vim.bo.filetype = vim.b.hex_original_ft or "binary"
  vim.b.hex_original_ft = nil
end, { desc = "Restore buffer from hex dump" })

api.nvim_create_user_command("HexToggle", function()
  cmd(fn.getline(1):match("^%x%x%x%x%x%x%x%x:") and "HexRestore" or "HexDump")
end, { desc = "Toggle hex dump view" })

-- Run: run commands asynchronously in a terminal split with quickfix integration
local prg_map = { make = "makeprg", lmake = "makeprg", grep = "grepprg", lgrep = "grepprg" }

local function expand_cmd(input)
  local current = fn.expand("%:p")
  local alt = fn.expand("#:p")
  local expanded = input:gsub("%%%%:p", current):gsub("%%%%", current):gsub("#", alt)

  if not expanded:match("^:") then return expanded end

  local vim_cmd = expanded:sub(2)
  local name, args = vim_cmd:match("^(%S+)%s*(.*)")
  if name == "!" then return args end
  if prg_map[name] then
    local prg = vim.o[prg_map[name]]
    return prg:find("%$%*") and prg:gsub("%$%*", args) or prg .. " " .. args
  end
  return vim_cmd
end

api.nvim_create_user_command("Run", function(opts)
  local run_cmd = expand_cmd(opts.args)
  local efm = vim.o.errorformat

  cmd("botright new")
  cmd("resize " .. math.floor(vim.o.lines / 4))
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.swapfile = false
  vim.b.no_auto_close = true

  local buf = api.nvim_get_current_buf()
  fn.jobstart(run_cmd, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        if not api.nvim_buf_is_valid(buf) then return end
        local lines = api.nvim_buf_get_lines(buf, 0, -1, false)
        local parsed = fn.getqflist({ efm = efm, lines = lines })
        local items = parsed.items or {}
        local has_errors = false
        for _, item in ipairs(items) do
          if item.valid == 1 then has_errors = true; break end
        end
        if has_errors then
          local win = fn.bufwinid(buf)
          if win ~= -1 then api.nvim_win_close(win, true) end
          fn.setqflist(items, "r")
          fn.setqflist({}, "a", { title = run_cmd })
          cmd.copen()
        end
      end)
    end,
  })

  api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true, silent = true })
  api.nvim_create_autocmd("TermClose", {
    buffer = 0,
    callback = function()
      pcall(api.nvim_feedkeys, api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), "n", false)
    end,
  })
end, {
  desc = "Run a command asynchronously in a terminal split",
  nargs = "+",
  complete = function(arg_lead)
    if arg_lead:match("^:") then
      local results = fn.getcompletion(arg_lead:sub(2), "command")
      for i, v in ipairs(results) do results[i] = ":" .. v end
      return results
    end
    local seen, results = {}, {}
    for _, type in ipairs({ "shellcmd", "file" }) do
      for _, v in ipairs(fn.getcompletion(arg_lead, type)) do
        if not seen[v] then seen[v] = true; results[#results + 1] = v end
      end
    end
    return results
  end,
})

-- Todo: find TODOs in project, file, or selection
local todo_keywords = { "TODO", "FIXME", "HACK", "XXX", "BUG", "WARN" }
local todo_comment_types = { comment = true, line_comment = true, block_comment = true }

api.nvim_create_user_command("Todo", function(args)
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
end, {
  range = true,
  desc = ":Todo (project) | :%Todo (file) | :'<,'>Todo (selection)",
})
