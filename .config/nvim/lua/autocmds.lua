local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt

local user_config_group = augroup('UserConfig', { clear = true })

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
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  group = user_config_group,
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

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

-- Enable signcolumn in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = user_config_group,
  command = 'setlocal signcolumn=auto',
})

-- Auto-resize splits when window is resized
autocmd("VimResized", {
  group = user_config_group,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})


-- Create directories when saving files
autocmd("BufWritePre", {
  group = user_config_group,
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

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

-- Auto toggle folds based on search/navigation
vim.on_key(function(char)
  local key = vim.fn.keytrans(char)
  local searchKeys = { "n", "N", "*", "#", "/", "?" }
  local searchConfirmed = (key == "<CR>" and vim.fn.getcmdtype():find("[/?]") ~= nil)
  if not (searchConfirmed or vim.fn.mode() == "n") then return end
  local searchKeyUsed = searchConfirmed or (vim.tbl_contains(searchKeys, key))

  local pauseFold = vim.opt.foldenable:get() and searchKeyUsed
  local unpauseFold = not (vim.opt.foldenable:get()) and not searchKeyUsed
  if pauseFold then
    vim.opt.foldenable = false
  elseif unpauseFold then
    vim.opt.foldenable = true
    vim.cmd.normal("zv") -- Keep the current fold open
  end
end, vim.api.nvim_create_namespace("auto_pause_folds"))

-- Save folds between sessions
local function remember(mode)
  -- Avoid complications with special filetypes
  local ignoredFts = { "TelescopePrompt", "DressingSelect", "DressingInput", "toggleterm", "gitcommit", "replacer",
    "harpoon", "help", "qf" }
  if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then return end

  if mode == "save" then
    vim.cmd.mkview(1)
  else
    pcall(function() vim.cmd.loadview(1) end) -- pcall, since new files have no view yet
  end
end
autocmd("BufWinLeave", {
  group = user_config_group,
  pattern = "?*",
  callback = function() remember("save") end,
})
autocmd("BufWinEnter", {
  group = user_config_group,
  pattern = "?*",
  callback = function() remember("load") end,
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
