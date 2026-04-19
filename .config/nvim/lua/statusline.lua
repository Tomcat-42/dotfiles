local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local autocmd = api.nvim_create_autocmd

local function setup_hls()
  local hls = {
    StlModeNORMAL   = "ErrorMsg",
    StlModeINSERT   = "ModeMsg",
    StlModeVISUAL   = "Constant",
    StlModeREPLACE  = "Keyword",
    StlModeCOMMAND  = "Function",
    StlModeTERMINAL = "Type",
    StlModeSELECT   = "Special",
    StlVcs          = "Added",
    StlLsp          = "Comment",
    StlSearch       = "Search",
    StlMacro        = "ErrorMsg",
    StlWarn         = "WarningMsg",
    StlExitOk       = "DiagnosticOk",
    StlExitFail     = "DiagnosticError",
    StlFt           = "Visual",
  }
  for name, link in pairs(hls) do
    api.nvim_set_hl(0, name, { link = link })
  end
end

setup_hls()
autocmd("ColorScheme", { callback = setup_hls })

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
      end
    )
    return
  end

  local git_root = vim.fs.root(0, ".git")
  if git_root then
    vim.uv.fs_open(git_root .. "/.git/HEAD", "r", 438, function(err, fd)
      if err or not fd then
        vcs_cache[bufnr] = ""
        return
      end
      vim.uv.fs_read(fd, 256, 0, function(err2, data)
        vim.uv.fs_close(fd)
        if err2 or not data then
          vcs_cache[bufnr] = ""
          return
        end
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

local function update_lsp_cache(buf)
  local names = vim.iter(vim.lsp.get_clients({ bufnr = buf }))
    :map(function(c) return (c.name:gsub("language.server", "ls")) end)
    :totable()
  lsp_cache[buf] = #names > 0 and table.concat(names, ", ") or ""
end

autocmd("LspAttach", {
  callback = function(args)
    update_lsp_cache(args.buf)
    cmd.redrawstatus()
  end,
})

autocmd("LspDetach", {
  callback = function(args)
    vim.defer_fn(function()
      update_lsp_cache(args.buf)
      cmd.redrawstatus()
    end, 100)
  end,
})

autocmd("BufWipeout", {
  callback = function(args)
    vcs_cache[args.buf] = nil
    lsp_cache[args.buf] = nil
  end,
})

local mode_map = {
  n = "NORMAL", i = "INSERT", v = "VISUAL",
  V = "V-LINE", ["\22"] = "V-BLOCK",
  c = "COMMAND", s = "SELECT", S = "S-LINE",
  ["\19"] = "S-BLOCK",
  R = "REPLACE", t = "TERMINAL", nt = "N-TERMINAL",
}

local mode_hl_map = {
  n = "StlModeNORMAL", i = "StlModeINSERT",
  v = "StlModeVISUAL", V = "StlModeVISUAL", ["\22"] = "StlModeVISUAL",
  c = "StlModeCOMMAND",
  s = "StlModeSELECT", S = "StlModeSELECT", ["\19"] = "StlModeSELECT",
  R = "StlModeREPLACE", t = "StlModeTERMINAL", nt = "StlModeNORMAL",
}

local term_exitcode = require("vim._core.util").term_exitcode

local function colored(group, text)
  return "%#" .. group .. "#" .. text .. "%#StatusLine#"
end

function _G.statusline_mode()
  local mode = api.nvim_get_mode().mode
  return colored(mode_hl_map[mode] or "StlModeNORMAL", " " .. (mode_map[mode] or mode:upper()) .. " ")
end

function _G.statusline_extra()
  local parts = {}
  local bufnr = api.nvim_get_current_buf()
  local bo = vim.bo[bufnr]

  local exitcode = term_exitcode()
  if exitcode ~= "" then
    parts[#parts + 1] = colored(exitcode == "[Exit: 0]" and "StlExitOk" or "StlExitFail", exitcode)
  end

  local ok, d = pcall(require, "dap")
  if ok and d.status() ~= "" then parts[#parts + 1] = colored("StlMacro", d.status()) end

  local reg = fn.reg_recording()
  if reg ~= "" then parts[#parts + 1] = colored("StlMacro", "recording @" .. reg) end

  if vim.v.hlsearch == 1 then
    local sc_ok, sc = pcall(fn.searchcount, { maxcount = 999 })
    if sc_ok and sc.total and sc.total > 0 then
      parts[#parts + 1] = colored("StlSearch", "[" .. sc.current .. "/" .. sc.total .. "]")
    end
  end

  local vcs = vcs_cache[bufnr] or ""
  if vcs ~= "" then parts[#parts + 1] = colored("StlVcs", vcs) end

  local lsp = lsp_cache[bufnr] or ""
  if lsp ~= "" then parts[#parts + 1] = colored("StlLsp", "[" .. lsp .. "]") end

  local ft = bo.filetype
  if ft ~= "" then parts[#parts + 1] = colored("StlFt", " " .. ft .. " ") end

  local warns = {}
  local enc = bo.fileencoding
  if enc ~= "" and enc ~= "utf-8" then warns[#warns + 1] = enc end
  if bo.fileformat ~= "unix" then warns[#warns + 1] = bo.fileformat end
  if bo.buftype == "" and not bo.expandtab then warns[#warns + 1] = "tabs" end
  if #warns > 0 then
    parts[#parts + 1] = colored("StlWarn", "[" .. table.concat(warns, ", ") .. "]")
  end

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
