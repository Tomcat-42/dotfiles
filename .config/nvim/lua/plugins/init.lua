vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/zbirenbaum/copilot.lua",
  "https://github.com/copilotlsp-nvim/copilot-lsp",
  "https://github.com/echasnovski/mini.base16",
  "https://github.com/echasnovski/mini.diff",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://codeberg.org/Jorenar/nvim-dap-disasm",
  "https://git.sr.ht/~chinmay/clangd_extensions.nvim",
})

require("plugins.ui2")
require("plugins.base16")
require("plugins.diff")
require("plugins.surround")
require("plugins.treesitter")
require("plugins.dap")
require("plugins.copilot")
require("plugins.clangd_extensions")
