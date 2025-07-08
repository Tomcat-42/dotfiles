local map = vim.keymap.set
local g = vim.g
local opt = vim.opt

-- === Leader Keys ===
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

-- === UI & Navigation ===
map("n", "<leader>r", "<cmd>restart<cr>", { desc = "Restart Neovim", silent = true })
map("n", "<Esc>", "<cmd>noh<cr>")                        -- Clear search highlights
map({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- Disable accidental space key usage
map('n', '<leader>w', '<cmd>set wrap!<cr>')
-- map({ "n", "x" }, "j", function() return vim.v.count > 0 and "j" or "gj" end, { noremap = true, expr = true })
-- map({ "n", "x" }, "k", function() return vim.v.count > 0 and "k" or "gk" end, { noremap = true, expr = true })

-- Better window navigation
map("n", '<C-h>', '<C-w>h')
map("n", '<C-j>', '<C-w>j')
map("n", '<C-k>', '<C-w>k')
map("n", '<C-l>', '<C-w>l')

-- Disable arrow keys
map('', '<Up>', '<Nop>')
map('', '<Down>', '<Nop>')
map('', '<Left>', '<Nop>')
map('', '<Right>', '<Nop>')

-- === Editing Enhancements ===
map("n", "J", "mzJ`z")            -- Join lines and restore cursor
map("v", "K", ":m '<-2<cr>gv=gv") -- Move selected text up

map("n", "<C-d>", "<C-d>zz")      -- Keep cursor centered on scrolling
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")            -- Keep search matches centered
map("n", "N", "Nzzzv")

map("x", "<leader>p", "\"_dp") -- Paste over selection without losing register

-- map("i", "<C-c>", "<esc>")     -- Make <C-c> behave like <esc>
-- map("n", "Q", "<nop>")         -- Disable Ex mode
-- map("i", "jk", "<esc>")        -- Pressing jk in insert mode will exit insert mode
-- map("i", "kj", "<esc>")        -- Pressing kj in insert mode will exit insert mode
-- map("i", "<esc>", "<nop>")     -- Disable <esc> in insert mode

-- === Clipboard & Registers ===
map("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
map("v", "<leader>y", "\"+y")
map("n", "<leader>Y", "\"+Y")

map("n", "<leader>p", "\"+p", { desc = "Paste from clipboard" })
map("v", "<leader>p", "\"+p")
map("n", "<leader>P", "\"+P")

map("v", "<leader>d", "\"+d")
map("n", "<leader>D", "\"+D")

map({ "n", "v", "x" }, '<leader>yy', '"+yy', { noremap = true, silent = true, desc = 'Yank line to clipboard' })
map({ "n", "v", "x" }, '<leader>Y', '"+yy')
map({ "n", "v", "x" }, '<C-a>', 'gg0vG$', { noremap = true, silent = true, desc = 'Select all' })

map('i', '<C-p>', '<C-r>+', { noremap = true, silent = true, desc = 'Paste from clipboard in insert mode' })

map("x", "<leader>P", '"_dP', { desc = "Paste over selection without erasing unnamed register" })

-- === Buffer & Tab Management ===
map("n", "<leader>bd", "<cmd>bd!<cr>")         -- Close buffer
map("n", "<leader>bn", "<cmd>bn<cr>")          -- Next buffer
map("n", "<leader>bp", "<cmd>bp<cr>")          -- Previous buffer
map("n", "<leader>bb", "<cmd>ls<cr>:b<space>") -- List buffers

map('n', 'tt', ':tabnew<CR>')                  -- New tab
map('n', 'tc', ':tabclose<CR>')                -- Close tab
map('n', 'tn', ':tabnext<CR>')                 -- Next tab
map('n', 'tp', ':tabprevious<CR>')             -- Previous tab
map('n', 'tmn', ':tabm +1<CR>')                -- Move tab right
map('n', 'tmp', ':tabm -1<CR>')                -- Move tab left

-- === Splits ===
-- map('n', '<M-e>', '<cmd>vsplit<cr>')
-- map('n', '<M-o>', '<cmd>split<cr>')
-- map('n', '<M-q>', '<cmd>q<cr>')

-- === Search & Replace ===
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Substitute word under cursor
map('n', '<leader>s', '*:%s///g<left><left>')                                 -- Rename current word
map('x', '<leader>s', '"hy:%s/<C-r>h//g<left><left>')                         -- Rename selection

-- === Compilation & Execution ===
map("n", "<leader>m", "<cmd>make<cr>")
map("n", "<leader>x", "<cmd>!chmod +x % && ./% %<CR>", { silent = true })

-- === Quickfix & Location Lists ===
map("n", "<leader>co", "<cmd>copen<cr>zz")
map("n", "<leader>lo", "<cmd>lopen<cr>zz")

-- === Terminal ===
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
map("n", "<leader><cr>", "<cmd>term<cr><cmd>startinsert<cr>")
map("n", "<C-s><C-v>", "<cmd>vsplit term://fish<cr><cmd>startinsert<cr>", { desc = "Open terminal in vertical split" })
map("n", "<C-s><C-s>", "<cmd>split term://fish<cr><cmd>startinsert<cr>", { desc = "Open terminal in horizontal split" })

-- === Treesitter ===
map("n", "<C-k>", "<cmd>InspectTree<cr>", { noremap = true, silent = true, desc = "Show Treesitter Syntax Tree" })

-- === Diff Mode ===
if opt.diff:get() then
  map('n', ']c', ']czz')
  map('n', '[c', '[czz')
  map('n', '<leader><left>', '<cmd>diffget LOCAL<cr>', { desc = 'Get changes from local', noremap = true })
  map('n', '<leader><up>', '<cmd>diffget BASE<cr>', { desc = 'Get changes from base', noremap = true })
  map('n', '<leader><right>', '<cmd>diffget REMOTE<cr>', { desc = 'Get changes from remote', noremap = true })
end

-- === NetRw ===
map("n", "<leader>e", "<cmd>Ex<cr>")
