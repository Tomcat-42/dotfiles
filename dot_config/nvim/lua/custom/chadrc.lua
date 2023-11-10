local M = {}

M.options = {
  nvchad_branch = "v2.0",
  permanent_undo = true,
  ruler = false,
  hidden = true,
  ignorecase = true,
  mouse = "a",
  cmdheight = 1,
  updatetime = 250,
  timeoutlen = 400,
  clipboard = "unnamedplus",
  number = true,
  -- relative numbers in normal mode tool at the bottom of options.lua
  relativenumber = true,
  numberwidth = 2,
  expandtab = true,
  shiftwidth = 2,
  smartindent = true,
  mapleader = " ",
  autosave = false,
  enable_insertNav = true,
  nu = true,
  tabstop = 4,
  softtabstop = 4,
  wrap = false,
  termiguicolors = true,
  hlsearch = true,
  incsearch = true,
}

M.ui = {
  ------------------------------- base46 -------------------------------------
  -- hl = highlights
  hl_add = {},
  hl_override = {},
  changed_themes = {},
  theme_toggle = { "radium", "one_light" },
  theme = "radium",
  transparency = true,
  lsp_semantic_tokens = true,
  italic_comments = true,

  -- https://github.com/NvChad/base46/tree/v2.0/lua/base46/extended_integrations
  extended_integrations = {
    "alpha",
    "bufferline",
    "codeactionmenu",
    "dap",
    "hop",
    "lspsaga",
    "navic",
    "notify",
    "rainbowdelimiters",
    "todo",
    "trouble",
  },

  -- cmp themeing
  cmp = {
    icons = true,
    lspkind_text = true,
    style = "flat_dark", -- default/flat_light/flat_dark/atom/
    border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
    selected_item_bg = "colored", -- colored / simple
  },

  telescope = { style = "bordered" }, -- borderless / bordered

  ------------------------------- nvchad_ui modules -----------------------------
  statusline = {
    theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "default",
    overriden_modules = function(modules)
      local present, arduino = pcall(require, "custom.configs.arduino")
      -- check for filetype == arduino
      if present and vim.bo.filetype == "arduino" then
        table.insert(modules, 13, arduino.status())
      end
    end,
  },

  -- lazyload it when there are 1+ buffers
  tabufline = {
    show_numbers = false,
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },

  -- nvdash (dashboard)
  nvdash = {
    load_on_startup = false,

    header = {
      "           ▄ ▄                   ",
      "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
      "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
      "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
      "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
      "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
      "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
      "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
      "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
    },

    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc m a", "Telescope marks" },
      { "  Themes", "Spc t h", "Telescope themes" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },

  cheatsheet = { theme = "grid" }, -- simple/grid

  lsp = {
    -- show function signatures i.e args as you type
    signature = {
      disabled = false,
      silent = true, -- silences 'no signature help available' message from appearing
    },
  },
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
