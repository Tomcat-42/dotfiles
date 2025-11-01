-- Builtin plugins
require('vim._extui').enable {}
vim.cmd [[
  packadd nvim.undotree
  packadd nvim.difftool
]]

-- Remote plugins
local gh = "https://github.com/"
vim.pack.add({
  gh .. "echasnovski/mini.base16",
  { src = gh .. "nvim-treesitter/nvim-treesitter", version = "main", },
  gh .. "nvim-lua/plenary.nvim",
  gh .. "/neovim/nvim-lspconfig",
  gh .. "mfussenegger/nvim-dap",
  gh .. "igorlfs/nvim-dap-view",
  gh .. "theHamsta/nvim-dap-virtual-text",
  gh .. "zbirenbaum/copilot.lua",
})

require("plugins.base16")
require("plugins.treesitter")
require("plugins.dap")
require("plugins.copilot")
