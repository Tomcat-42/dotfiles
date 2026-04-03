local map = vim.keymap.set

-- === Leader Keys ===
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

-- === Movement ===
map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end,
  { expr = true, silent = true, desc = "Down (wrap-aware)" })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end,
  { expr = true, silent = true, desc = "Up (wrap-aware)" })
map("n", "<C-d>", "<C-d>zz", { silent = true })
map("n", "<C-u>", "<C-u>zz", { silent = true })
map("n", "n", "nzzzv", { silent = true })
map("n", "N", "Nzzzv", { silent = true })

map('', '<Up>', '<Nop>')
map('', '<Down>', '<Nop>')
map('', '<Left>', '<Nop>')
map('', '<Right>', '<Nop>')

-- === UI & Navigation ===
map("n", "<Esc>", "<cmd>noh | redrawstatus<cr>", { silent = true })
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
map('n', '<leader>w', '<cmd>set wrap!<cr>', { silent = true, desc = "Toggle wrap" })
map("n", "<leader>R", "<cmd>restart<cr>", { silent = true, desc = "Restart Neovim" })
map("n", "<leader>rc", "<cmd>e ~/.config/nvim/init.lua<cr>", { silent = true, desc = "Edit config" })
map("n", "<leader>e", "<cmd>Ex<cr>", { silent = true, desc = "Open NetRW" })
map("n", "<leader>u", "<cmd>Undotree<cr>", { silent = true, desc = "Toggle undotree" })
map("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<cr>', { silent = true, desc = "cd to file dir" })
map("n", "<leader>pu", vim.pack.update, { silent = true, desc = "Update plugins" })
map("n", "<leader>pc", function()
  vim.pack.del(
    vim.iter(vim.pack.get())
    :filter(function(x) return not x.active end)
    :map(function(x) return x.spec.name end)
    :totable())
end, { silent = true, desc = "Clean plugins" })
map("n", "<leader>pl", function()
  vim.pack.update(nil, { offline = true })
end, { silent = true, desc = "List plugins" })
map("n", "<leader>i", "<cmd>InspectTree<cr>", { silent = true, desc = "Treesitter tree" })

-- === Window Navigation ===
map("n", '<C-h>', '<C-w>h', { silent = true })
map("n", '<C-j>', '<C-w>j', { silent = true })
map("n", '<C-k>', '<C-w>k', { silent = true })
map("n", '<C-l>', '<C-w>l', { silent = true })

-- === Splits ===
map("n", "<leader>sv", "<cmd>vsplit<cr>", { silent = true, desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<cr>", { silent = true, desc = "Split horizontally" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { silent = true, desc = "Increase height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { silent = true, desc = "Decrease height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { silent = true, desc = "Decrease width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { silent = true, desc = "Increase width" })

-- === Editing ===
map("n", "<A-j>", "<cmd>m .+1<cr>==", { silent = true, desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
map("v", "<", "<gv", { silent = true, desc = "Indent left and reselect" })
map("v", ">", ">gv", { silent = true, desc = "Indent right and reselect" })
map("n", "J", "mzJ`z", { silent = true, desc = "Join lines (keep cursor)" })

-- === Clipboard ===
map("n", "<leader>y", '"+y', { silent = true, desc = "Yank to clipboard" })
map("v", "<leader>y", '"+y', { silent = true, desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { silent = true, desc = "Yank line to clipboard" })
map("n", "<leader>p", '"+p', { silent = true, desc = "Paste from clipboard" })
map("v", "<leader>p", '"+p', { silent = true, desc = "Paste from clipboard" })
map("n", "<leader>P", '"+P', { silent = true, desc = "Paste before from clipboard" })
map("v", "<leader>d", '"+d', { silent = true, desc = "Delete to clipboard" })
map("n", "<leader>D", '"+D', { silent = true, desc = "Delete to end to clipboard" })
map("x", "<leader>P", '"_dP', { silent = true, desc = "Paste over without yanking" })
map('i', '<C-p>', '<C-r>+', { silent = true, desc = "Paste from clipboard (insert)" })
map({ "n", "v", "x" }, '<C-a>', 'gg0vG$', { silent = true, desc = "Select all" })

-- === Buffers ===
map("n", "<leader>bd", "<cmd>bd!<cr>", { silent = true, desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bn<cr>", { silent = true, desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bp<cr>", { silent = true, desc = "Previous buffer" })

-- === Tabs ===
map('n', 'tt', '<cmd>tabnew<cr>', { silent = true, desc = "New tab" })
map('n', 'td', '<cmd>tabclose<cr>', { silent = true, desc = "Close tab" })
map('n', 'tn', '<cmd>tabnext<cr>', { silent = true, desc = "Next tab" })
map('n', 'tp', '<cmd>tabprevious<cr>', { silent = true, desc = "Previous tab" })
map('n', 'tmn', '<cmd>tabm +1<cr>', { silent = true, desc = "Move tab right" })
map('n', 'tmp', '<cmd>tabm -1<cr>', { silent = true, desc = "Move tab left" })

-- === Search & Replace ===
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map('x', '<leader>s', '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace selection" })

map("n", "<leader>fa", function()
  local path = vim.fn.expand("%:p")
  if path == "" then return end
  vim.fn.setreg("+", path)
  print("file ->", path)
end, { silent = true, desc = "Copy file path" })


map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- === Compilation ===
map('n', '<leader>m', '<cmd>Run! :make<cr>', { silent = true, desc = "Build (make)" })
map('n', '<leader>M', '<cmd>Run!<cr>', { silent = true, desc = "Re-run last command" })
map("n", "<leader>x", "<cmd>!chmod +x % && ./% %<cr>", { silent = true, desc = "Make executable and run" })

-- === Quickfix & Location Lists ===
map("n", "<leader>c", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end, { silent = true, desc = "Toggle quickfix" })

map("n", "<leader>l", function()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.loclist == 1 then
      vim.cmd.lclose()
      return
    end
  end
  vim.cmd.lopen()
end, { silent = true, desc = "Toggle loclist" })

-- === Terminal ===
map('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true, desc = "Exit terminal mode" })
map("n", "<leader><cr>", "<cmd>term<cr><cmd>startinsert<cr>", { silent = true, desc = "Open terminal" })
map("n", "<C-s><C-v>", "<cmd>vsplit term://fish<cr><cmd>startinsert<cr>", { silent = true, desc = "Terminal in vsplit" })
map("n", "<C-s><C-s>", "<cmd>split term://fish<cr><cmd>startinsert<cr>", { silent = true, desc = "Terminal in split" })
map("n", "<C-s><C-t>", "<cmd>tabnew term://fish<cr><cmd>startinsert<cr>", { silent = true, desc = "Terminal in tab" })

-- === Git Blame ===
map({ 'n', 'v' }, '<leader>bb', '<cmd>GitBlame<cr>', { silent = true, desc = "Git blame" })
map('n', '<leader>bc', '<cmd>GitBlameClear<cr>', { silent = true, desc = "Git blame clear" })

-- === Arglist (poor man's harpoon) ===
map('n', '<leader>a', "<cmd>$arga<cr>", { silent = true, desc = "Add file to arglist" })

for i, k in ipairs({ "h", "j", "k", "l" }) do
  map('n', '<C-' .. k .. '>', "<cmd>argu " .. i .. "<cr>", { silent = true, desc = "Go to arg " .. i })
  map('n', '<leader>h' .. k, "<cmd>" .. i .. "arga<cr>", { silent = true, desc = "Add to arg " .. i })
  map('n', '<leader>D' .. k, "<cmd>" .. i .. "argd<cr>", { silent = true, desc = "Delete arg " .. i })
end

map('n', '<leader>q', function()
  local args = vim.fn.argv()
  if #args == 0 then return end
  local items = {}
  for _, f in ipairs(args) do
    items[#items + 1] = { filename = f, lnum = 1, text = f }
  end
  vim.fn.setqflist(items, 'r')
  vim.cmd.copen()
end, { silent = true, desc = "Show arglist in quickfix" })

-- === Diff Mode ===
if vim.opt.diff:get() then
  map('n', ']c', ']czz', { silent = true })
  map('n', '[c', '[czz', { silent = true })
  map('n', '<leader><left>', '<cmd>diffget LOCAL<cr>', { silent = true, desc = "Get from LOCAL" })
  map('n', '<leader><up>', '<cmd>diffget BASE<cr>', { silent = true, desc = "Get from BASE" })
  map('n', '<leader><right>', '<cmd>diffget REMOTE<cr>', { silent = true, desc = "Get from REMOTE" })
end
