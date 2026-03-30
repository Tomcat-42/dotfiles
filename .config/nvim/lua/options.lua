local opt = vim.opt
local g = vim.g

-- === Variables ===
g.projects_dir = vim.env.HOME .. '/dev'
g.c_syntax_for_h = 1

-- === UI ===
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.signcolumn = "number"
opt.cursorline = true
opt.colorcolumn = "100"
opt.wrap = false
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.showmode = false
opt.showmatch = true
opt.termguicolors = true
opt.background = "dark"
opt.laststatus = 3
opt.showtabline = 1
opt.tabline = ''
opt.list = false
opt.conceallevel = 0
opt.concealcursor = ""
opt.fillchars = {
  vert = "│",
  fold = " ",
  eob = "~",
  diff = "╱",
  msgsep = " ",
}

-- === Windows & Splits ===
opt.splitbelow = true
opt.splitright = true
opt.winborder = "single"
opt.pumborder = "single"
opt.diffopt:append("linematch:60")

-- === Messages ===
opt.errorbells = false
opt.shortmess = "atIcWFsO"
opt.messagesopt = "history:1000,hit-enter"

-- === Folding ===
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 99
opt.foldcolumn = "0"
opt.foldtext = ""
vim.wo.foldmethod = "expr"

-- === Indentation ===
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.breakindent = true

-- === Editing ===
opt.mouse = ""
opt.backspace = "indent,eol,start"
opt.whichwrap:append "<>[]hl"
opt.iskeyword:append("-")
opt.selection = "inclusive"
opt.modifiable = true
opt.encoding = "UTF-8"
opt.path:append("**")

-- === Search ===
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'
opt.grepprg = 'rg --vimgrep --no-heading --smart-case'

-- === Completion ===
opt.completeopt = "menu,menuone,noinsert,noselect,popup,fuzzy"
opt.autocomplete = false
opt.pumheight = 10
opt.pumblend = 0
opt.winblend = 0
opt.wildoptions = 'pum,fuzzy'
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore = {
  "*.o", "*.obj", "*.pyc", "*.pyo",
  "*.swp", "*.swo",
  "*.zip", "*.tar.gz", "*.tar.bz2", "*.tar.xz", "*.rar", "*.7z",
  "*/.git/*", "*/.svn/*", "*/.hg/*", "*/.bzr/*",
  "*/node_modules/*", "*/bower_components/*", "*/vendor/*",
  "*/target/*", "*/build/*", "*/zig-out/*", "*/*cache/*", "*/dist/*", "*/__pycache__/*",
  "*.DS_Store",
  "*.ko", "*.mod", "*.mod.c", "*.cmd", "*.d", "*.order", "*.symvers",
  "vmlinux", "System.map", "cscope.*", "tags", "TAGS",
  ".config", ".config.old",
  "*.patch", "*.diff",
}

-- === Performance ===
opt.lazyredraw = true
opt.redrawtime = 10000
opt.maxmempattern = 20000
opt.synmaxcol = 300
opt.timeoutlen = 500
opt.ttimeoutlen = 0
opt.updatetime = 250

-- === Backup & Undo ===
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.directory = vim.fn.stdpath("data") .. "/swap"
opt.autoread = true
opt.autowrite = false
opt.hidden = true
opt.autochdir = false

-- === NetRW ===
g.netrw_banner = 0
g.netrw_liststyle = 3
g.netrw_keepdir = 1
g.netrw_localrm = "rm -r"
g.netrw_winsize = 25
g.netrw_localcopydircmd = "cp -r"
g.netrw_sort_by = "name"

-- === Disabled Providers ===
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0
