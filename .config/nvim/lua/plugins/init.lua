local gh = "https://github.com/"
local cb = "https://codeberg.org/"

vim.pack.add({
  gh .. "echasnovski/mini.base16",
  gh .. "nvim-treesitter/nvim-treesitter",
  gh .. "nvim-lua/plenary.nvim",
  gh .. "jiaoshijie/undotree",
  gh .. "/neovim/nvim-lspconfig",
  gh .. "igorlfs/nvim-dap-view",
  gh .. "theHamsta/nvim-dap-virtual-text",
  -- cb .. "mfussenegger/nvim-dap"
})

require("plugins.base16")
require("plugins.treesitter")
require("plugins.undotree")
-- require("plugins.dap")
