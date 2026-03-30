vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/echasnovski/mini.base16",
  "https://github.com/echasnovski/mini.diff",
  "https://github.com/echasnovski/mini.surround",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/zbirenbaum/copilot.lua",
})
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

require("vim._core.ui2").enable {}
require("plugins.base16")
require("plugins.diff")
require("plugins.surround")
require("plugins.treesitter")
require("plugins.dap")
require("plugins.copilot")
