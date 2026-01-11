local map = vim.keymap.set
local g = vim.g
local opt = vim.opt

-- === Leader Keys ===
vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")

-- undotree
map("n", "<leader>u", ":Undotree<cr>", { silent = true, desc = "Toggle undotree" })

-- cd current dir
map("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>')

-- vim.pack.update
map("n", "<leader>pu", vim.pack.update, { desc = "Update plugins", silent = true })

-- === UI & Navigation ===
map("n", "<leader>R", "<cmd>restart<cr>", { desc = "Restart Neovim", silent = true })
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
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
map("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

map("n", "<C-d>", "<C-d>zz") -- Keep cursor centered on scrolling
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")       -- Keep search matches centered
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
map("n", "<leader>fb", "<cmd>ls<cr>:b<space>") -- List buffers

map('n', 'tt', ':tabnew<CR>')                  -- New tab
map('n', 'td', ':tabclose<CR>')                -- Close tab
map('n', 'tn', ':tabnext<CR>')                 -- Next tab
map('n', 'tp', ':tabprevious<CR>')             -- Previous tab
map('n', 'tmn', ':tabm +1<CR>')                -- Move tab right
map('n', 'tmp', ':tabm -1<CR>')                -- Move tab left

-- === Splits ===
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- === Search & Replace ===
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]) -- Substitute word under cursor
map('n', '<leader>s', '*:%s///g<left><left>')                                 -- Rename current word
map('x', '<leader>s', '"hy:%s/<C-r>h//g<left><left>')                         -- Rename selection

-- === Compilation & Execution ===
map('n', '<leader>m', function()
  vim.cmd('make')

  local qflist = vim.fn.getqflist()
  if #qflist ~= 0 then
    vim.cmd('copen')
  end
end, { noremap = true, silent = true, desc = "Run make & open quickfix on error" })
map("n", "<leader>x", "<cmd>!chmod +x % && ./% %<CR>", { silent = true })

-- === Quickfix & Location Lists ===
map("n", "<leader>c", function()
  local windows = vim.fn.getwininfo()
  local qf_is_open = false

  for _, win in ipairs(windows) do
    if win.quickfix == 1 then
      qf_is_open = true
      break
    end
  end

  if qf_is_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
  vim.cmd("normal! zz")
end)
map("n", "<leader>l", function()
  local windows = vim.fn.getwininfo()
  local ll_is_open = false

  for _, win in ipairs(windows) do
    if win.loclist == 1 then
      ll_is_open = true
      break
    end
  end

  if ll_is_open then
    vim.cmd("lclose")
  else
    vim.cmd("lopen")
  end
  vim.cmd("normal! zz")
end)

-- === Terminal ===
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
map("n", "<leader><cr>", "<cmd>term<cr><cmd>startinsert<cr>")
map("n", "<C-s><C-v>", "<cmd>vsplit term://fish<cr><cmd>startinsert<cr>", { desc = "Open terminal in vertical split" })
map("n", "<C-s><C-s>", "<cmd>split term://fish<cr><cmd>startinsert<cr>", { desc = "Open terminal in horizontal split" })
map("n", "<C-s><C-t>", "<cmd>tabnew term://fish<cr><cmd>startinsert<cr>", { desc = "Open terminal in new tab" })

-- === Treesitter ===
map("n", "<leader>i", "<cmd>InspectTree<cr>", { noremap = true, silent = true, desc = "Show Treesitter Syntax Tree" })

-- builtin "Fuzzy" finding
map("n", "<leader>ff", ":find ", { desc = "Find file" })
map("n", "<leader>fh", ":help ", { desc = "Find help" })
map("n", "<leader>fm", ":Man ", { desc = "Find help" })
map("n", "<leader>fw", function()
    local search_pattern = vim.fn.input("find pattern: ")
    if search_pattern and search_pattern ~= '' then
      local command = "silent! grep! -w " .. vim.fn.shellescape(search_pattern)
      vim.cmd(command)
      local qflist = vim.fn.getqflist()
      if #qflist == 0 then
        print("No matches found for: " .. search_pattern)
      else
        print("Found " .. #qflist .. " matches.")
        vim.cmd("copen")
      end
    else
      print("No search pattern provided.")
    end
  end,
  { noremap = true, desc = "Find word (ripgrep)" }
)

-- === Diff Mode ===
if opt.diff:get() then
  map('n', ']c', ']czz')
  map('n', '[c', '[czz')
  map('n', '<leader><left>', '<cmd>diffget LOCAL<cr>', { desc = 'Get changes from local', noremap = true })
  map('n', '<leader><up>', '<cmd>diffget BASE<cr>', { desc = 'Get changes from base', noremap = true })
  map('n', '<leader><right>', '<cmd>diffget REMOTE<cr>', { desc = 'Get changes from remote', noremap = true })
end

map("n", "<leader>fa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end)

-- === Git Blame ===
map({ 'n', 'v' }, '<Leader>bb', ':GitBlame<CR>', { silent = true, desc = "Git Blame (current line or selection)" })
map('n', '<Leader>bc', ':GitBlameClear<CR>', { silent = true, desc = "Git Blame Clear" })

-- === NetRw ===
map("n", "<leader>e", "<cmd>Ex<cr>")

-- === Poor man's harpoon
map('n', '<leader>a', "<cmd>$arga<cr>", { silent = true, desc = "Add current file to arg list" })

for i, k in ipairs({ "h", "j", "k", "l" }) do
  map('n', '<C-' .. k .. '>', "<CMD>argu " .. i .. "<CR>", { silent = true, desc = "Go to arg " .. i })
  map('n', '<leader>h' .. k, "<CMD>" .. i .. "arga<CR>", { silent = true, desc = "Add current to arg " .. i })
  map('n', '<leader>D' .. k, "<CMD>" .. i .. "argd<CR>", { silent = true, desc = "Delete current arg" })
end

map('n', '<leader>q', function()
  local list = vim.fn.argv()
  if #list > 0 then
    local qf_items = {}
    for _, filename in ipairs(list) do
      table.insert(qf_items, {
        filename = filename,
        lnum = 1,
        text = filename
      })
    end
    vim.fn.setqflist(qf_items, 'r')
    vim.cmd.copen()
  end
end, { silent = true, desc = "Show args in qf" })
