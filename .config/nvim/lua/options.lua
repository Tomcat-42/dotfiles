local opt = vim.opt
local g = vim.g
local gopt = vim.g
local wo = vim.wo

-- === Folding ===
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 99
opt.foldcolumn = "0"
opt.foldtext = ""
wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
wo.foldmethod = "expr"

-- === Indentation ===
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- === UI Settings ===
opt.shortmess:append "atI"
opt.signcolumn = "number" -- or "auto"
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.cursorline = true
opt.colorcolumn = "80"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.colorcolumn = "80"
opt.laststatus = 3
opt.showmode = true
opt.termguicolors = true
opt.background = "dark"
-- opt.guicursor = ""
opt.splitbelow = true
opt.splitright = true
opt.whichwrap:append "<>[]hl"
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.statusline = table.concat(
  {
    ' %t',
    '%r',
    '%m',
    '%=',
    '%{&filetype}',
    ' %2p%%',
    ' %3l:%-2c '
  },
  ''
)

-- === Misc ===
opt.mouse = ""
opt.timeoutlen = 1000 -- 600
opt.updatetime = 250
opt.autochdir = false
opt.breakindent = true

-- === Backup & Swap ===
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.directory = vim.fn.stdpath("data") .. "/swap"

-- === Searching ===
opt.ignorecase = true
opt.smartcase = true

-- === Completion ===
opt.completeopt = "menuone,noinsert,noselect,popup,fuzzy"
opt.completeopt:append('fuzzy') -- Use fuzzy matching for built-in completion
opt.inccommand = 'split'

-- === NetRW ===
-- gopt.netrw_banner = 0
-- gopt.netrw_liststyle = 3
-- gopt.netrw_keepdir = 1
-- gopt.netrw_localrm = "rm -r"
--gopt.netrw_winsize = 25
-- gopt.netrw_localcopydircmd = "cp -r"

-- === Custom Shell ===
-- opt.shell = "nu"
-- opt.shellcmdflag = "--stdin --no-newline -c"
-- opt.shellredir = "out+err> %s"
-- opt.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
-- opt.shelltemp = false
-- opt.shellxescape = ""
-- opt.shellxquote = ""
-- opt.shellquote = ""
