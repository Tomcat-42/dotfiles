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

autocmd("TextYankPost", {
  group = g,
  callback = function() vim.hl.on_yank() end,
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

local prompt_ns = api.nvim_create_namespace("terminal_prompt_markers")
autocmd("TermRequest", {
  group = g,
  callback = function(args)
    if args.data.sequence:match("^\027]133;A") then
      api.nvim_buf_set_extmark(args.buf, prompt_ns, args.data.cursor[1] - 1, 0, {
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

local view_g = augroup("auto_view", { clear = true })
local view_ignore = { "gitcommit", "gitrebase", "svg", "hgcommit", "nvim-pack" }

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  group = view_g,
  callback = function(args)
    if vim.b[args.buf].view_activated then
      cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

autocmd("BufWinEnter", {
  group = view_g,
  callback = function(args)
    if vim.b[args.buf].view_activated then return end
    local ft = vim.bo[args.buf].filetype
    if vim.bo[args.buf].buftype ~= "" or ft == "" or vim.tbl_contains(view_ignore, ft) then return end
    vim.b[args.buf].view_activated = true
    cmd.loadview({ mods = { emsg_silent = true } })
  end,
})
