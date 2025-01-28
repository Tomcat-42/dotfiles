local opt = vim.opt
local wo = vim.wo
local gopt = vim.g
local env = vim.env

-- folds
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldnestmax = 99
opt.foldcolumn = "0"
opt.foldtext = ""

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.shortmess:append "atI"
opt.signcolumn = "auto"
opt.mouse = ""
opt.smartindent = true
opt.autoindent = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 1
opt.cursorline = true
-- opt.clipboard = "unnamedplus"
opt.termguicolors = true
-- opt.guicursor = ""
opt.signcolumn = "number"
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.directory = vim.fn.stdpath("data") .. "/swap"
opt.scrolloff = 8
opt.updatetime = 50
opt.colorcolumn = "80"
opt.completeopt = 'menuone,noselect'
opt.laststatus = 3
-- vim.opt.fillchars = {
--   vert = "▕", -- alternatives │
--   fold = " ",
--   eob = " ", -- suppress ~ at EndOfBuffer
--   diff = "╱", -- alternatives = ⣿ ░ ─
--   msgsep = "‾",
--   foldopen = "▾",
--   foldsep = "│",
--   foldclose = "▸",
-- }
opt.showmode = true
opt.showmode = true
opt.splitbelow = true
opt.splitright = true
opt.whichwrap:append "<>[]hl"
opt.autochdir = false


gopt.netrw_banner = 0
gopt.netrw_liststyle = 3
gopt.netrw_keepdir = 1
gopt.netrw_localrm = "rm -r"
--gopt.netrw_winsize = 25
gopt.netrw_localcopydircmd = "cp -r"

opt.completeopt:append('fuzzy') -- Use fuzzy matching for built-in completion

-- nushell fuckery
-- opt.shell = "nu"
-- opt.shellcmdflag = "--stdin --no-newline -c"
-- opt.shellredir = "out+err> %s"
-- opt.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
-- opt.shelltemp = false
-- opt.shellxescape = ""
-- opt.shellxquote = ""
-- opt.shellquote = ""
