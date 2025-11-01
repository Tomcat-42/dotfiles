local autocmd = vim.api.nvim_create_autocmd
local keymap = vim.keymap.set
local input = vim.ui.input
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt
local bo = vim.bo
local wo = vim.wo

local user_config_group = augroup('UserConfig', { clear = true })

-- === NetRW improvements ===
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

-- === Default vert help/man ===
autocmd("FileType", {
  group = user_config_group,
  pattern = { "help", "man" },
  command = "wincmd L",
})


-- === Highlight on Yank ===
-- See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = user_config_group,
  pattern = '*',
})

-- === Quickfix ===
-- Don't list quickfix buffers
autocmd("FileType", {
  group = user_config_group,
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- === Cursor Position ===
-- Restore cursor position
-- autocmd({ "BufReadPost" }, {
--   pattern = { "*" },
--   group = user_config_group,
--   callback = function()
--     vim.api.nvim_exec('silent! normal! g`"zv', false)
--   end,
-- })

-- === Terminal ===
-- Auto-close interactive terminal buffers if the command exits successfully,
-- because non-interactive commands generally are launched for it's output.
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

-- Enable signcolumn/number in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = user_config_group,
  callback = function()
    wo.number = true
    wo.signcolumn = 'number'
  end
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = user_config_group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})


-- Create directories when saving files
-- autocmd("BufWritePre", {
--   group = user_config_group,
--   callback = function()
--     if vim.bo.filetype == 'nvim-pack' then return end
--
--     local dir = vim.fn.expand('<afile>:p:h')
--     if vim.fn.isdirectory(dir) == 0 then
--       vim.fn.mkdir(dir, 'p')
--     end
--   end,
-- })

-- Terminal prompt markers
local ns = vim.api.nvim_create_namespace('terminal_prompt_markers')
autocmd('TermRequest', {
  group = user_config_group,
  callback = function(args)
    if string.match(args.data.sequence, '^\027]133;A') then
      local lnum = args.data.cursor[1]
      vim.api.nvim_buf_set_extmark(args.buf, ns, lnum - 1, 0, {
        -- Replace with sign text and highlight group of choice
        sign_text = '=>',
        sign_hl_group = 'SpecialChar',
      })
    end
  end,
})

-- === Folding ===
-- Pause folds when searching
opt.foldopen:remove { "search" }
vim.keymap.set("n", "/", "zn/", { desc = "Search & Pause Folds" })

-- Save folds between sessions
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

-- Close folds with `h` at BoL
-- vim.keymap.set("n", "h", function()
--   local onIndentOrFirstNonBlank = vim.fn.virtcol(".") <= vim.fn.indent(".") + 1
--   local shouldCloseFold = vim.tbl_contains(vim.opt_local.foldopen:get(), "hor")
--   if onIndentOrFirstNonBlank and shouldCloseFold then
--     local wasFolded = pcall(vim.cmd.normal, "zc")
--     if wasFolded then return end
--   end
--   vim.cmd.normal{"h", bang = true}
-- end, { desc = "h (+ close fold at BoL)" })
--)
--
