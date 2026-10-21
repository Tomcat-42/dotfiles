local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local g = augroup("UserConfig", { clear = true })

autocmd("FileType", {
  group = augroup("big_file", { clear = true }),
  pattern = "bigfile",
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or ""
    end)
  end,
})

autocmd("FileType", {
  group = g,
  pattern = "netrw",
  callback = function()
    local map = vim.keymap.set
    local bopts = { buffer = true, silent = true }
    map("n", "<C-c>", function() cmd.bdelete() end, bopts)
    map("n", "<Tab>", "mf", vim.tbl_extend("force", bopts, { remap = true }))
    map("n", "<S-Tab>", "mF", vim.tbl_extend("force", bopts, { remap = true }))
    map("n", "%", function()
      local dir = vim.b.netrw_curdir or fn.expand("%:p:h")
      vim.ui.input({ prompt = "Enter filename: " }, function(name)
        if name and name ~= "" then
          cmd("!touch " .. fn.shellescape(dir .. "/" .. name))
          api.nvim_feedkeys(vim.keycode("<C-l>"), "n", false)
        end
      end)
    end, bopts)
  end,
})

autocmd("FileType", {
  group = g,
  pattern = { "help", "man" },
  command = "wincmd L",
})

autocmd("FileType", {
  group = g,
  pattern = "qf",
  callback = function() vim.opt_local.buflisted = false end,
})

autocmd("FileType", {
  group = g,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = false
  end,
})

autocmd({ "TextYankPost", "TextPutPost" }, {
  group = g,
  callback = function() vim.hl.hl_op({ higroup = "IncSearch", timeout = 300 }) end,
})

autocmd("BufReadPost", {
  group = g,
  callback = function()
    if vim.o.diff then return end
    local mark = api.nvim_buf_get_mark(0, '"')
    if mark[1] >= 1 and mark[1] <= api.nvim_buf_line_count(0) then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

autocmd("BufWritePre", {
  group = g,
  callback = function()
    if vim.bo.filetype == "nvim-pack" then return end
    local dir = fn.expand("<afile>:p:h")
    if fn.isdirectory(dir) == 0 then fn.mkdir(dir, "p") end
  end,
})

autocmd("TermOpen", {
  group = g,
  callback = function()
    vim.wo.number = true
    vim.wo.signcolumn = "number"
  end,
})

autocmd("TermRequest", {
  group = g,
  callback = function(args)
    if args.data.sequence:match("^\027]133;A") then
      api.nvim_buf_set_extmark(args.buf, api.nvim_create_namespace("terminal_prompt_markers"), args.data.cursor[1] - 1, 0,
        {
          sign_text = "=>",
          sign_hl_group = "SpecialChar",
        })
    end
  end,
})

autocmd("VimResized", {
  group = g,
  callback = function() cmd("tabdo wincmd =") end,
})


-- Views: persist cursor, scroll, curdir, and fold open/close state.
-- Fold *options* (foldmethod, foldexpr, …) are stripped from view files
-- after mkview so stale values never override treesitter/LSP on restore.

local view_g = augroup("auto_view", { clear = true })
local view_ignore = { "gitcommit", "gitrebase", "svg", "hgcommit", "nvim-pack" }
local home_pat = "^" .. vim.pesc(vim.env.HOME)

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  group = view_g,
  callback = function(args)
    if not vim.b[args.buf].view_activated then return end
    cmd.mkview({ mods = { emsg_silent = true } })
    local name = api.nvim_buf_get_name(args.buf)
    if name == "" then return end
    local path = fn.expand(vim.o.viewdir) .. "/" .. name:gsub(home_pat, "~"):gsub("/", "=+") .. "="
    local ok, lines = pcall(fn.readfile, path)
    if not ok then return end
    local clean = vim.tbl_filter(function(l) return not l:match("^setlocal%s+n?o?fold") end, lines)
    if #clean < #lines then fn.writefile(clean, path) end
  end,
})

autocmd("BufWinEnter", {
  group = view_g,
  callback = function(args)
    if vim.b[args.buf].view_activated then return end
    local ft = vim.bo[args.buf].filetype
    if vim.bo[args.buf].buftype ~= "" or ft == "" or vim.tbl_contains(view_ignore, ft) then return end
    vim.b[args.buf].view_activated = true
    vim.schedule(function() cmd.loadview({ mods = { emsg_silent = true } }) end)
  end,
})
