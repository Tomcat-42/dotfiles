vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")

vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/echasnovski/mini.base16",
  "https://github.com/echasnovski/mini.diff",
  "https://github.com/echasnovski/mini.surround",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/zbirenbaum/copilot.lua",
})

require("plugins.ui2")
require("plugins.base16")
require("plugins.diff")
require("plugins.surround")
require("plugins.treesitter")
require("plugins.dap")
require("plugins.copilot")
