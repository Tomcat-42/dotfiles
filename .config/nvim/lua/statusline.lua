local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local autocmd = api.nvim_create_autocmd

local vcs_cache = {}

local function update_vcs_info()
  local bufnr = api.nvim_get_current_buf()

  local jj_root = vim.fs.root(0, ".jj")
  if jj_root then
    vim.system(
      { "jj", "log", "--no-graph", "-r", "@", "-T", 'if(bookmarks, bookmarks.join(", "), change_id.shortest(8))' },
      { cwd = jj_root, text = true },
      function(result)
        vcs_cache[bufnr] = result.code == 0 and vim.trim(result.stdout) or ""
        vim.schedule(cmd.redrawstatus)
      end)
    return
  end

  local git_root = vim.fs.root(0, ".git")
  if git_root then
    vim.uv.fs_open(git_root .. "/.git/HEAD", "r", 438, function(err, fd)
      if err or not fd then vcs_cache[bufnr] = ""; return end
      vim.uv.fs_read(fd, 256, 0, function(err2, data)
        vim.uv.fs_close(fd)
        if err2 or not data then vcs_cache[bufnr] = ""; return end
        local line = data:match("^[^\n]+")
        vcs_cache[bufnr] = line and (line:match("ref: refs/heads/(.+)") or line:sub(1, 8)) or ""
        vim.schedule(cmd.redrawstatus)
      end)
    end)
    return
  end

  vcs_cache[bufnr] = ""
end

autocmd({ "BufEnter", "DirChanged", "FocusGained" }, { callback = update_vcs_info })

local lsp_cache = {}

autocmd("LspAttach", {
  callback = function(args)
    local names = vim.iter(vim.lsp.get_clients({ bufnr = args.buf }))
      :map(function(c) return (c.name:gsub("language.server", "ls")) end)
      :totable()
    lsp_cache[args.buf] = #names > 0 and table.concat(names, ", ") or ""
    cmd.redrawstatus()
  end,
})

autocmd("LspDetach", {
  callback = function(args)
    vim.defer_fn(function()
      local names = vim.iter(vim.lsp.get_clients({ bufnr = args.buf }))
        :map(function(c) return (c.name:gsub("language.server", "ls")) end)
        :totable()
      lsp_cache[args.buf] = #names > 0 and table.concat(names, ", ") or ""
      cmd.redrawstatus()
    end, 100)
  end,
})

local lsp_progress = {}

autocmd("LspProgress", {
  pattern = { "begin", "end" },
  callback = function(args)
    if not args.data then return end
    local value = args.data.params.value
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    lsp_progress.client = client and client.name or nil
    lsp_progress.title = value.kind ~= "end" and value.title or nil
    if value.kind == "end" then
      vim.defer_fn(function() cmd.redrawstatus() end, 3000)
    else
      cmd.redrawstatus()
    end
  end,
})

autocmd("BufWipeout", {
  callback = function(args)
    vcs_cache[args.buf] = nil
    lsp_cache[args.buf] = nil
  end,
})

local mode_map = {
  n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK",
  c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK",
  R = "REPLACE", t = "TERMINAL", nt = "N-TERMINAL",
  no = "OP-PENDING", nov = "OP-PENDING", noV = "OP-PENDING", ["no\22"] = "OP-PENDING",
}

local mode_hl = {
  n = "ErrorMsg", i = "ModeMsg",
  v = "Constant", V = "Constant", ["\22"] = "Constant",
  c = "Function", s = "Special", S = "Special", ["\19"] = "Special",
  R = "Keyword", t = "Type", nt = "ErrorMsg",
  no = "Comment", nov = "Comment", noV = "Comment", ["no\22"] = "Comment",
}

local term_exitcode = require("vim._core.util").term_exitcode

local function hl(group, text)
  return "%#" .. group .. "#" .. text .. "%#StatusLine#"
end

function _G.statusline_mode()
  local mode = api.nvim_get_mode().mode
  return hl(mode_hl[mode] or "ErrorMsg", " " .. (mode_map[mode] or mode:upper()) .. " ")
end

function _G.statusline_extra()
  local parts = {}
  local bufnr = api.nvim_get_current_buf()
  local bo = vim.bo[bufnr]
  local ft = bo.filetype

  local exitcode = term_exitcode()
  if exitcode ~= "" then
    parts[#parts + 1] = hl(exitcode == "[Exit: 0]" and "DiagnosticOk" or "DiagnosticError", exitcode)
  end

  local dap_ok, d = pcall(require, "dap")
  if dap_ok and d.status() ~= "" then parts[#parts + 1] = hl("ErrorMsg", d.status()) end

  if lsp_progress.client and lsp_progress.title and not vim.startswith(api.nvim_get_mode().mode, "i") then
    parts[#parts + 1] = hl("Comment", lsp_progress.client .. ": " .. lsp_progress.title)
  end

  local reg = fn.reg_recording()
  if reg ~= "" then parts[#parts + 1] = hl("ErrorMsg", "recording @" .. reg) end

  if vim.v.hlsearch == 1 then
    local sc_ok, sc = pcall(fn.searchcount, { maxcount = 999 })
    if sc_ok and sc.total and sc.total > 0 then
      parts[#parts + 1] = hl("Search", "[" .. sc.current .. "/" .. sc.total .. "]")
    end
  end

  local vcs = vcs_cache[bufnr] or ""
  if vcs ~= "" then
    local diff_ok, diff = pcall(require, "mini.diff")
    if diff_ok then
      local buf_data = diff.get_buf_data(bufnr)
      if buf_data and buf_data.hunks and #buf_data.hunks > 0 then
        local n = #buf_data.hunks
        vcs = vcs .. hl("Comment", " (" .. n .. (n == 1 and " hunk)" or " hunks)"))
      end
    end
    parts[#parts + 1] = hl("Added", vcs)
  end

  local lsp = lsp_cache[bufnr] or ""
  if lsp ~= "" then parts[#parts + 1] = hl("Comment", "[" .. lsp .. "]") end

  if ft ~= "" then parts[#parts + 1] = hl("Visual", " " .. ft .. " ") end

  if ft == "markdown" or ft == "text" then
    local wc = api.nvim_buf_call(bufnr, fn.wordcount)
    local vis = fn.mode():match("^[vV\22]")
    parts[#parts + 1] = hl("Comment",
      (vis and wc.visual_words .. "/" or "") .. wc.words .. "w " ..
      (vis and wc.visual_chars .. "/" or "") .. wc.chars .. "c")
  end

  local warns = {}
  if bo.fileencoding ~= "" and bo.fileencoding ~= "utf-8" then warns[#warns + 1] = bo.fileencoding end
  if bo.fileformat ~= "unix" then warns[#warns + 1] = bo.fileformat end
  if bo.buftype == "" and not bo.expandtab then warns[#warns + 1] = "tabs" end
  if #warns > 0 then parts[#parts + 1] = hl("WarningMsg", "[" .. table.concat(warns, ", ") .. "]") end

  return #parts > 0 and table.concat(parts, " ") .. " " or ""
end

vim.o.statusline = table.concat({
  "%{%v:lua._G.statusline_mode()%} %<%f %h%w%m%r",
  "[%n]",
  "%=",
  "%{%v:lua._G.statusline_extra()%}",
  "%{% &busy > 0 ? '\u{25d0} ' : '' %}",
  "%{% v:lua.vim.diagnostic.status() != '' ? v:lua.vim.diagnostic.status() .. ' ' : '' %}",
  "%-14.(%l,%c%V%) %P",
})
