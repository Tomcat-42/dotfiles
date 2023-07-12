local M = {}

M.plugins = require "custom.plugins"

M.options = {
  -- nvChad = {
  --   update_branch = "dev",
  -- },
  autosave = true,
  nu = true,
  relativenumber = true,
  tabstop = 4,
  softtabstop = 4,
  shiftwidth = 4,
  expandtab = true,
  smartindent = true,
  wrap = false,
  termiguicolors = true,
  hlsearch = true,
  incsearch = true,
  updatetime = 50

}

M.ui = {
  -- theme stuff
  theme = "tokyonight",
  transparency = true,
  theme_toggle = { "chadracula", "everforest_light" },

  hl_override = require("custom.highlights").overriden_hlgroups,

  -- changed_themes = {
  --   chadracula = {
  --     base_16 = {
  --       background = "#000000",
  --       foreground = "#ffffff",
  --       base00 = "#000000",
  --     },
  --     base_30 = {
  --       background = "black",
  --       foreground = "white",
  --     },
  --   },
  -- },
}

M.mappings = require "custom.mappings"

return M
