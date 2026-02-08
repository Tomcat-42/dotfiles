local opt = vim.opt
local g = vim.g
local wo = vim.wo

-- === Variables ===
vim.g.projects_dir = vim.env.HOME .. '/dev'

-- === Folding ===
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 99
opt.foldcolumn = "0"
opt.foldtext = ""
wo.foldmethod = "expr"

-- === Indentation ===
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

-- === UI Settings ===
opt.errorbells = false
opt.lazyredraw = true
opt.winborder = "single"
opt.pumborder = "single"
opt.shortmess = "atIcWFsO"
opt.messagesopt = "history:1000,hit-enter"
opt.signcolumn = "number"
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.cursorline = true
opt.colorcolumn = "80"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.laststatus = 3
opt.showmode = true
opt.termguicolors = true
opt.background = "dark"
opt.splitbelow = true
opt.splitright = true
opt.whichwrap:append "<>[]hl"
vim.o.list = false
opt.diffopt:append("linematch:60")
opt.wildoptions = 'pum,fuzzy'
opt.wildmenu = true
opt.wildmode = "longest:full,full"
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
opt.showtabline = 1
opt.tabline = ''

-- === Misc ===
opt.mouse = ""
opt.timeoutlen = 1000
opt.updatetime = 250
opt.autochdir = false
opt.breakindent = true
opt.iskeyword:append("-")
opt.backspace = "indent,eol,start"
opt.path:append("**")
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'
g.c_syntax_for_h = 1


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
opt.autocomplete = true
opt.inccommand = 'split'
opt.pumheight = 10

-- === NetRW ===
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_keepdir = 1
g.netrw_localrm = "rm -r"
g.netrw_winsize = 25
g.netrw_localcopydircmd = "cp -r"
g.netrw_sort_by = "name"

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
