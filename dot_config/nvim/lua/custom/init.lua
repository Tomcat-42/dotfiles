vim.filetype.add {
  extension = { ebnf = "ebnf", bnf = "ebnf", ll = "llvm", pl = "prolog" },
}

vim.cmd [[imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")]]
vim.cmd [[let g:copilot_no_tab_map = v:true]]
vim.cmd [[let g:copilot_filetypes = {'markdown': v:true, "yaml": v:true}]]

-- Remover mappings <C-j> do mod "core"

require "custom.commands"
require "custom.autocmds"
