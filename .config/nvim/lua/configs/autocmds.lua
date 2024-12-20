local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local opt = vim.opt

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- dont list quickfix buffers
autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

-- Restore cursor position
autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

autocmd('TermOpen', {
  group = augroup('TermOpen', { clear = true }),
  callback = function()
    opt.number = true
    opt.relativenumber = true
  end,
})

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

-- folds
-- pause folds when searching
opt.foldopen:remove { "search" }
vim.keymap.set("n", "/", "zn/", { desc = "Search & Pause Folds" })
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
    vim.cmd.normal("zv") -- after closing folds, keep the *current* fold open
  end
end, vim.api.nvim_create_namespace("auto_pause_folds"))

-- Save folds between sessions
local function remember(mode)
  -- avoid complications with some special filetypes
  local ignoredFts = { "TelescopePrompt", "DressingSelect", "DressingInput", "toggleterm", "gitcommit", "replacer",
    "harpoon", "help", "qf" }
  if vim.tbl_contains(ignoredFts, vim.bo.filetype) or vim.bo.buftype ~= "" or not vim.bo.modifiable then return end

  if mode == "save" then
    vim.cmd.mkview(1)
  else
    pcall(function() vim.cmd.loadview(1) end) -- pcall, since new files have no view yet
  end
end
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "?*",
  callback = function() remember("save") end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "?*",
  callback = function() remember("load") end,
})

-- close with h and l
-- vim.keymap.set("n", "h", function()
-- 	local onIndentOrFirstNonBlank = vim.fn.virtcol(".") <= vim.fn.indent(".") + 1
-- 	local shouldCloseFold = vim.tbl_contains(vim.opt_local.foldopen:get(), "hor")
-- 	if onIndentOrFirstNonBlank and shouldCloseFold then
-- 		local wasFolded = pcall(vim.cmd.normal, "zc")
-- 		if wasFolded then return end
-- 	end
-- 	vim.cmd.normal{"h", bang = true}
-- end, { desc = "h (+ close fold at BoL)" })
