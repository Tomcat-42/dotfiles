local gh = "https://github.com/"

vim.pack.add({
  gh .. "echasnovski/mini.base16",
  gh .. "nvim-treesitter/nvim-treesitter",
  gh .. "nvim-lua/plenary.nvim",
  gh .. "jiaoshijie/undotree",
  gh .. "/neovim/nvim-lspconfig",
  gh .. "igorlfs/nvim-dap-view",
  gh .. "theHamsta/nvim-dap-virtual-text",
  gh .. "mfussenegger/nvim-dap",
  gh .. "zbirenbaum/copilot.lua",
})

require("plugins.base16")
require("plugins.treesitter")
require("plugins.undotree")
require("plugins.dap")
require("plugins.copilot")
