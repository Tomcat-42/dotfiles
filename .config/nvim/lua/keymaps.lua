local map = vim.keymap.set
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

vim.g.mapleader = vim.keycode("<space>")
vim.g.maplocalleader = vim.keycode("<cr>")
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

for _, k in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do map("", k, "<Nop>") end
map("n", "j", function() return vim.v.count == 0 and "gj" or "j" end,
  { expr = true, silent = true, desc = "Down (wrap-aware)" })
map("n", "k", function() return vim.v.count == 0 and "gk" or "k" end,
  { expr = true, silent = true, desc = "Up (wrap-aware)" })
map("n", "<C-d>", "<C-d>zz", { silent = true })
map("n", "<C-u>", "<C-u>zz", { silent = true })
map("n", "n", "nzzzv", { silent = true })
map("n", "N", "Nzzzv", { silent = true })

map("n", "<A-j>", function()
    cmd("m .+1")
    cmd.normal({ "==", bang = true })
  end,
  { silent = true, desc = "Move line down" })
map("n", "<A-k>", function()
    cmd("m .-2")
    cmd.normal({ "==", bang = true })
  end,
  { silent = true, desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
map("v", "<", "<gv", { silent = true, desc = "Indent left and reselect" })
map("v", ">", ">gv", { silent = true, desc = "Indent right and reselect" })
map("n", "J", "mzJ`z", { silent = true, desc = "Join lines (keep cursor)" })

map({ "n", "v" }, "<leader>y", '"+y', { silent = true, desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { silent = true, desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { silent = true, desc = "Paste from clipboard" })
map("n", "<leader>P", '"+P', { silent = true, desc = "Paste before from clipboard" })
map("v", "<leader>d", '"+d', { silent = true, desc = "Delete to clipboard" })
map("n", "<leader>D", '"+D', { silent = true, desc = "Delete to end to clipboard" })
map("x", "<leader>P", '"_dP', { silent = true, desc = "Paste over without yanking" })
map("i", "<C-p>", "<C-r>+", { silent = true, desc = "Paste from clipboard (insert)" })
map({ "n", "v", "x" }, "<C-a>", "gg0vG$", { silent = true, desc = "Select all" })

map("n", "/", "zn/", { desc = "Search & pause folds" })
map("n", "<Esc>", function()
  cmd.nohlsearch()
  cmd.redrawstatus()
end, { silent = true })
map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
map("x", "<leader>s", '"hy:%s/<C-r>h//g<left><left>', { desc = "Replace selection" })

for _, d in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. d .. ">", function() cmd.wincmd(d) end, { silent = true })
end
map("n", "<leader>sv", cmd.vsplit, { silent = true, desc = "Split vertically" })
map("n", "<leader>sh", cmd.split, { silent = true, desc = "Split horizontally" })
map("n", "<C-Up>", function() cmd("resize +2") end, { silent = true, desc = "Increase height" })
map("n", "<C-Down>", function() cmd("resize -2") end, { silent = true, desc = "Decrease height" })
map("n", "<C-Left>", function() cmd("vertical resize -2") end, { silent = true, desc = "Decrease width" })
map("n", "<C-Right>", function() cmd("vertical resize +2") end, { silent = true, desc = "Increase width" })

map("n", "<leader>bd", function() api.nvim_buf_delete(0, { force = true }) end, { silent = true, desc = "Delete buffer" })
map("n", "<leader>bn", cmd.bnext, { silent = true, desc = "Next buffer" })
map("n", "<leader>bp", cmd.bprevious, { silent = true, desc = "Previous buffer" })

map("n", "tt", cmd.tabnew, { silent = true, desc = "New tab" })
map("n", "td", cmd.tabclose, { silent = true, desc = "Close tab" })
map("n", "tn", cmd.tabnext, { silent = true, desc = "Next tab" })
map("n", "tp", cmd.tabprevious, { silent = true, desc = "Previous tab" })
map("n", "tmn", function() cmd("tabm +1") end, { silent = true, desc = "Move tab right" })
map("n", "tmp", function() cmd("tabm -1") end, { silent = true, desc = "Move tab left" })

local function toggle_list(prop, open, close)
  for _, win in ipairs(fn.getwininfo()) do
    if win[prop] == 1 then return cmd[close]() end
  end
  cmd[open]()
end

map("n", "<leader>c", function() toggle_list("quickfix", "copen", "cclose") end,
  { silent = true, desc = "Toggle quickfix" })
map("n", "<leader>l", function() toggle_list("loclist", "lopen", "lclose") end,
  { silent = true, desc = "Toggle loclist" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal mode" })
map("n", "<leader><cr>", function()
    cmd.term()
    cmd.startinsert()
  end,
  { silent = true, desc = "Open terminal" })
map("n", "<C-s><C-v>", function()
    cmd.vsplit("term://fish")
    cmd.startinsert()
  end,
  { silent = true, desc = "Terminal in vsplit" })
map("n", "<C-s><C-s>", function()
    cmd.split("term://fish")
    cmd.startinsert()
  end,
  { silent = true, desc = "Terminal in split" })
map("n", "<C-s><C-t>", function()
    cmd.tabnew("term://fish")
    cmd.startinsert()
  end,
  { silent = true, desc = "Terminal in tab" })

map("n", "<leader>w", function() vim.wo.wrap = not vim.wo.wrap end,
  { silent = true, desc = "Toggle wrap" })
map("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, desc = "Toggle diagnostics" })
map("n", "<leader>tt", function()
  local lsp = vim.lsp
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled({ bufnr = 0 }))
  pcall(function() lsp.codelens.enable(not lsp.codelens.is_enabled({ bufnr = 0 }), { bufnr = 0 }) end)
  pcall(function() require("dap-view").virtual_text_toggle() end)
  pcall(function() require("mini.diff").toggle(0) end)
end, { silent = true, desc = "Toggle all overlays" })

map("n", "<leader>m", function() cmd("Run! :make") end, { silent = true, desc = "Build (make)" })
map("n", "<leader>M", function() cmd("Run!") end, { silent = true, desc = "Re-run last command" })
map("n", "<leader>x", function() cmd("!chmod +x % && ./% %") end, { silent = true, desc = "Make executable and run" })

map("n", "<leader>bb", function() cmd("%GitBlame") end, { silent = true, desc = "Git blame" })
map("v", "<leader>bb", ":GitBlame<cr>", { silent = true, desc = "Git blame (selection)" })
map("n", "<leader>bc", cmd.GitBlameClear, { silent = true, desc = "Git blame clear" })

map("n", "<leader>a", function() cmd("$arga") end, { silent = true, desc = "Add file to arglist" })

for i, k in ipairs({ "h", "j", "k", "l" }) do
  map("n", "<C-" .. k .. ">", function() cmd("argu " .. i) end, { silent = true, desc = "Go to arg " .. i })
  map("n", "<leader>h" .. k, function() cmd(i .. "arga") end, { silent = true, desc = "Add to arg " .. i })
  map("n", "<leader>D" .. k, function() cmd(i .. "argd") end, { silent = true, desc = "Delete arg " .. i })
end

map("n", "<leader>q", function()
  local args = fn.argv()
  if #args == 0 then return end
  local items = {}
  for _, f in ipairs(args) do
    items[#items + 1] = { filename = f, lnum = 1, text = f }
  end
  fn.setqflist(items, "r")
  cmd.copen()
end, { silent = true, desc = "Show arglist in quickfix" })

map("n", "<leader>R", function()
  local session = fn.stdpath("state") .. "/restart_session.vim"
  cmd("mksession! " .. fn.fnameescape(session))
  cmd("restart source " .. fn.fnameescape(session))
end, { silent = true, desc = "Restart Neovim" })
map("n", "<leader>rc", function() cmd.edit("~/.config/nvim/init.lua") end, { silent = true, desc = "Edit config" })
map("n", "<leader>e", cmd.Ex, { silent = true, desc = "Open NetRW" })
map("n", "<leader>u", cmd.Undotree, { silent = true, desc = "Toggle undotree" })
map("n", "<leader>i", cmd.InspectTree, { silent = true, desc = "Treesitter tree" })
map("n", "<leader>cd", function() fn.chdir(fn.expand("%:p:h")) end, { silent = true, desc = "cd to file dir" })
map("n", "<leader>fa", function()
  local path = fn.expand("%:p")
  if path == "" then return end
  fn.setreg("+", path)
  print("file ->", path)
end, { silent = true, desc = "Copy file path" })

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

map("n", "<leader>ff", ":find ", { desc = "Find file" })
map("n", "<leader>fb", ":Buffer ", { desc = "Buffers" })
map("n", "<leader>fh", ":H ", { desc = "Help" })
map("n", "<leader>fo", ":Recent ", { desc = "Recent files" })
map("n", "<leader>fc", ":Cmd ", { desc = "Commands" })
map("n", "<leader>fw", ":Grep ", { desc = "Grep (quickfix)" })
map("n", "<leader>fl", ":LiveGrep ", { desc = "Live grep" })
map("n", "<leader>fs", function() cmd.Symbols() end, { silent = true, desc = "Document symbols" })
map("n", "<leader>fS", ":WSymbols ", { desc = "Workspace symbols" })
map("n", "<leader>fm", ":Man ", { desc = "Man page" })
map("n", "<leader>fr", ":Bin ", { desc = "Run executable" })
map("n", "<leader>fk", ":Keymaps ", { desc = "Keymaps" })

local find_cmds = { find = true, fin = true, sfind = true, tabfind = true }
map("c", "<M-e>", "<Home><S-Right><C-w>edit<End>")
map("c", "<M-d>", function()
  local c = fn.getcmdline():match("^(%S+)")
  if not c or not find_cmds[c] then return end
  local arg = fn.getcmdline():match("^%S+%s+(.+)")
  if not arg or not vim.uv.fs_realpath(fn.expand(arg)) then
    return vim.notify("Invalid path", vim.log.levels.ERROR)
  end
  fn.feedkeys(vim.keycode("<C-U>") .. "edit " .. vim.fs.dirname(arg), "c")
end)
map("c", "<C-v>", "<Home><S-Right><C-w>vs<End>")
map("c", "<C-s>", "<Home><S-Right><C-w>sp<End>")
map("c", "<C-t>", "<Home><S-Right><C-w>tabe<End>")

if vim.opt.diff:get() then
  map("n", "]c", "]czz", { silent = true })
  map("n", "[c", "[czz", { silent = true })
  map("n", "<leader><left>", function() cmd("diffget LOCAL") end, { silent = true, desc = "Get from LOCAL" })
  map("n", "<leader><up>", function() cmd("diffget BASE") end, { silent = true, desc = "Get from BASE" })
  map("n", "<leader><right>", function() cmd("diffget REMOTE") end, { silent = true, desc = "Get from REMOTE" })
end
