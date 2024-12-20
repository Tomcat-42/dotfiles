local map = vim.keymap.set

vim.g.mapleader = " "

-- map("n", "<leader>e", "<cmd>Explore %:p:h<cr>")

-- as god has intended
map('', '<Up>', '<Nop>')
map('', '<Down>', '<Nop>')
map('', '<Left>', '<Nop>')
map('', '<Right>', '<Nop>')

-- buffers
map("n", "<leader>bd", "<cmd>bd!<cr>")
map("n", "<leader>bn", "<cmd>bn<cr>")
map("n", "<leader>bp", "<cmd>bp<cr>")
map("n", "<leader>bb", "<cmd>ls<cr>:b<space>")

-- builtin terminal emulator
map("n", "<leader><cr>", "<cmd>term<cr><cmd>startinsert<cr>")
map("t", "<esc>", "<C-\\><C-n>")

-- tabs
map('n', 'tt', ':tabnew<CR>')
map('n', 'tc', ':tabclose<CR>')
map('n', 'tn', ':tabnext<CR>')
map('n', 'tp', ':tabprevious<CR>')
map('n', 'tmn', ':tabm +1<CR>')
map('n', 'tmp', ':tabm -1<CR>')

-- splits
map('n', '<M-e>', '<cmd>vsplit<cr>')
map('n', '<M-o>', '<cmd>split<cr>')
map('n', '<M-q>', '<cmd>q<cr>')

-- better movement between windows
map("n", '<C-h>', '<C-w>h')
map("n", '<C-j>', '<C-w>j')
map("n", '<C-k>', '<C-w>k')
map("n", '<C-l>', '<C-w>l')

map("n", "J", "mzJ`z")
map("v", "K", ":m '<-2<cr>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", "\"_dp")

map("n", "<leader>y", "\"+y")
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+Y")

map("n", "<leader>p", "\"+p")
map("v", "<leader>p", "\"+p")
map("n", "<leader>P", "\"+P")

map("v", "<leader>d", "\"_d")
map("n", "<leader>D", "\"_D")
map("n", '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
map({ "v", "x" }, '<leader>y', '"+y', { noremap = true, silent = true, desc = 'Yank to clipboard' })
map({ "n", "v", "x" }, '<leader>yy', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
map({ "n", "v", "x" }, '<leader>Y', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
map({ "n", "v", "x" }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })
map({ 'n', 'v', 'x' }, '<leader>p', '"+p', { noremap = true, silent = true, desc = 'Paste from clipboard' })
map('i', '<C-p>', '<C-r>+', { noremap = true, silent = true, desc = 'Paste from clipboard from within insert mode' })
map("x", "<leader>P", '"_dP',
  { noremap = true, silent = true, desc = 'Paste over selection without erasing unnamed register' })


map("i", "<C-c>", "<esc>")

map("n", "Q", "<nop>")

map("n", "<leader>cn", "<cmd>cnext<cr>zz")
map("n", "<leader>cp", "<cmd>cprev<cr>zz")
map("n", "<leader>ln", "<cmd>lnext<cr>zz")
map("n", "<leader>lp", "<cmd>lprev<cr>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map('n', '<leader>s', '*:%s///g<left><left>')         -- Rename current word with <leader>F2
map('x', '<leader>s', '"hy:%s/<C-r>h//g<left><left>') -- Rename selected text in visual


map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

if vim.opt.diff:get() then
  map('n', ']c', ']czz')
  map('n', '[c', '[czz')
  map('n', '<leader><left>', '<cmd>diffget LOCAL<cr>', { desc = 'Get changes from local', noremap = true })
  map('n', '<leader><up>', '<cmd>diffget BASE<cr>', { desc = 'Get changes from base', noremap = true })
  map('n', '<leader><right>', '<cmd>diffget REMOTE<cr>', { desc = 'Get changes from remote', noremap = true })
end
