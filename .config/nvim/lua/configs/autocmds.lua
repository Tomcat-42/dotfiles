local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt

-- === Highlight on Yank ===
-- See `:help vim.highlight.on_yank()`
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- === Quickfix ===
-- Don't list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- === Cursor Position ===
-- Restore cursor position
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  group = augroup("RestoreCursor", { clear = true }),
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- === Terminal ===
-- Auto-close terminal buffers if the command exits successfully
autocmd('TermClose', {
  pattern = '*',
  callback = function()
    vim.schedule(function()
      if vim.bo.buftype == 'terminal' and vim.v.shell_error == 0 then
        vim.cmd('bdelete! ' .. vim.fn.expand('<abuf>'))
      end
    end)
  end,
})

-- Enable signcolumn in terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  command = 'setlocal signcolumn=auto',
})

-- Terminal prompt markers
local ns = vim.api.nvim_create_namespace('terminal_prompt_markers')
vim.api.nvim_create_autocmd('TermRequest', {
  callback = function(args)
    if string.match(args.data.sequence, '^\027]133;A') then
      local lnum = args.data.cursor[1]
      vim.api.nvim_buf_set_extmark(args.buf, ns, lnum - 1, 0, {
        -- Replace with sign text and highlight group of choice
        sign_text = '▶',
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
  pattern = "?*",
  callback = function() remember("save") end,
})
autocmd("BufWinEnter", {
  pattern = "?*",
  callback = function() remember("load") end,
})

-- Close folds with `h` at BoL (currently commented out)
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
