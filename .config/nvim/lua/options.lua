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
wo.foldmethod = "expr"
wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- === Indentation ===
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 0
opt.shiftround = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- === UI Settings ===
opt.errorbells = false
opt.lazyredraw = true
opt.showmatch = true
opt.matchtime = 2
opt.winborder = "single"
opt.shortmess = "atIcWFsO"
opt.messagesopt = "history:1000,hit-enter"
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
vim.o.list = false
-- vim.opt.listchars = {
--     -- tab = "▏ ",
--     trail = "·",
--     extends = "»",
--     precedes = "«",
-- }
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
opt.diffopt:append("linematch:60")
opt.wildoptions = 'pum,fuzzy'
opt.wildmenu = true
-- opt.wildmode = "longest:full,full"
vim.opt.wildignore = {
  "*.o",
  "*.obj",
  "*.pyc",
  "*.pyo",
  "*.swp",
  "*.swo",
  "*.zip",
  "*.tar.gz",
  "*.tar.bz2",
  "*.tar.xz",
  "*.rar",
  "*.7z",
  "*/.git/*",
  "*/.svn/*",
  "*/.hg/*",
  "*/.bzr/*",
  "*/node_modules/*",
  "*/bower_components/*",
  "*/vendor/*",
  "*/target/*",
  "*/build/*",
  "*/zig-out/*",
  "*/*cache/*",
  "*/dist/*",
  "*/__pycache__/*",
  "*.DS_Store",
  "*.ko",
  "*.mod",
  "*.mod.c",
  "*.cmd",
  "*.d",
  "*.order",
  "*.symvers",
  "vmlinux",
  "System.map",
  "cscope.*",
  "tags",
  "TAGS",
  ".config",
  ".config.old",
  "*.patch",
  "*.diff",
}
opt.showtabline = 1 -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
opt.tabline = ''    -- Use default tabline (empty string uses built-in)

-- === Misc ===
opt.mouse = ""
opt.timeoutlen = 1000 -- 600
opt.updatetime = 250
opt.autochdir = false
opt.breakindent = true
opt.iskeyword:append("-")
opt.backspace = "indent,eol,start"
opt.path:append("**")
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- === Backup & Swap ===
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.directory = vim.fn.stdpath("data") .. "/swap"
opt.autoread = true

-- === Searching ===
opt.ignorecase = true
opt.smartcase = true

-- === Completion ===
opt.completeopt = "menu,menuone,noinsert,noselect,popup,fuzzy"
opt.inccommand = 'split'
opt.pumheight = 10

-- === NetRW ===
gopt.netrw_banner = 0
gopt.netrw_liststyle = 3
gopt.netrw_keepdir = 1
gopt.netrw_localrm = "rm -r"
gopt.netrw_winsize = 25
gopt.netrw_localcopydircmd = "cp -r"

-- === Custom Shell ===
-- opt.shell = "nu"
-- opt.shellcmdflag = "--stdin --no-newline -c"
-- opt.shellredir = "out+err> %s"
-- opt.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
-- opt.shelltemp = false
-- opt.shellxescape = ""
-- opt.shellxquote = ""
-- opt.shellquote = ""
