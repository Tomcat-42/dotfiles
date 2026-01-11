vim.cmd.compiler("zig")
vim.opt_local.makeprg = "zig cc % $*"
