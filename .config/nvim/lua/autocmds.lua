local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local input = vim.ui.input
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt
local wo = vim.wo

local user_config_group = augroup('UserConfig', { clear = true })

autocmd('FileType', {
  group = augroup('big_file', { clear = true }),
  desc = 'Disable features in big files',
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(function()
      vim.bo[args.buf].syntax = vim.filetype.match { buf = args.buf } or ''
    end)
  end,
})


autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    keymap('n', '<C-c>', '<cmd>bd<CR>', { buffer = true, silent = true })
    keymap('n', '<Tab>', 'mf', { buffer = true, remap = true, silent = true })
    keymap('n', '<S-Tab>', 'mF', { buffer = true, remap = true, silent = true })
    keymap('n', '%', function()
      local dir = vim.b.netrw_curdir or vim.fn.expand('%:p:h')
      input({ prompt = 'Enter filename: ' }, function(input)
        if input and input ~= '' then
          local filepath = dir .. '/' .. input
          vim.cmd('!touch ' .. vim.fn.shellescape(filepath))
          vim.api.nvim_feedkeys('<C-l>', 'n', false)
        end
      end)
    end, { buffer = true, silent = true })
  end
})

autocmd("FileType", {
  group = user_config_group,
  pattern = { "help", "man" },
  command = "wincmd L",
})


autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = user_config_group,
  pattern = '*',
})

autocmd("FileType", {
  group = user_config_group,
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd('TermClose', {
  group = user_config_group,
  pattern = '*',
  callback = function()
    vim.schedule(function()
      if
          vim.bo.buftype == 'terminal'
          and vim.v.shell_error == 0
          and vim.fn.mode() == "t"
      then
        vim.cmd('bdelete! ' .. vim.fn.expand('<abuf>'))
      end
    end)
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = user_config_group,
  callback = function()
    wo.number = true
    wo.signcolumn = 'number'
  end
})

autocmd("VimResized", {
  group = user_config_group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})


autocmd("BufWritePre", {
  group = user_config_group,
  callback = function()
    if vim.bo.filetype == 'nvim-pack' then return end

    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

local ns = vim.api.nvim_create_namespace('terminal_prompt_markers')
autocmd('TermRequest', {
  group = user_config_group,
  callback = function(args)
    if string.match(args.data.sequence, '^\027]133;A') then
      local lnum = args.data.cursor[1]
      vim.api.nvim_buf_set_extmark(args.buf, ns, lnum - 1, 0, {
        sign_text = '=>',
        sign_hl_group = 'SpecialChar',
      })
    end
  end,
})

opt.foldopen:remove { "search" }
vim.keymap.set("n", "/", "zn/", { desc = "Search & Pause Folds" })

local view_group = augroup("auto_view", { clear = true })

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = view_group,
  callback = function(args)
    if vim.b[args.buf].view_activated then vim.cmd.mkview { mods = { emsg_silent = true } } end
  end,
})
autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = view_group,
  callback = function(args)
    if not vim.b[args.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = args.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit", "nvim-pack" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[args.buf].view_activated = true
        vim.cmd.loadview { mods = { emsg_silent = true } }
      end
    end
  end,
})

