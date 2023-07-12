local overrides = require "custom.plugins.overrides"

return {

  ----------------------------------------- default plugins ------------------------------------------

  ["folke/which-key.nvim"] = { disable = false },

  ["goolord/alpha-nvim"] = {
    disable = false,
    cmd = "Alpha",
    override_options = overrides.alpha,
  },

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.configs.lspconfig"
    end,
  },

  -- override default configs
  -- ["kyazdani42/nvim-tree.lua"] = {override_options = overrides.nvimtree},
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = overrides.treesitter,
  },
  ["lukas-reineke/indent-blankline.nvim"] = {
    override_options = overrides.blankline,
  },
  ["williamboman/mason.nvim"] = { override_options = overrides.mason },
  ["nvim-telescope/telescope.nvim"] = {
    module = "telescope",
    override_options = overrides.telescope,
  },

  ["NvChad/ui"] = { override_options = overrides.ui },

  --------------------------------------------- custom plugins ----------------------------------------------
  ["nvim-treesitter/nvim-treesitter-context"] = {
    after = "telescope.nvim",
    config = function()
      require "custom.plugins.configs.treesitter-context"
    end,
  },

  ["nvim-telescope/telescope-ui-select.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension "ui-select"
    end,
  },

  ["nvim-telescope/telescope-dap.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require("telescope").load_extension "dap"
    end,
  },

  ["nvim-treesitter/nvim-treesitter-refactor"] = { after = "nvim-treesitter" },

  ["folke/twilight.nvim"] = {
    config = function()
      require "custom.plugins.configs.twilight"
    end,
  },

  -- autoclose tags in html, jsx only
  ["windwp/nvim-ts-autotag"] = {
    ft = { "html", "javascriptreact" },
    after = "nvim-treesitter",
    config = function()
      local present, autotag = pcall(require, "nvim-ts-autotag")

      if present then
        autotag.setup()
      end
    end,
  },

  -- format & linting
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.configs.null-ls"
    end,
  },

  -- get highlight group under cursor
  ["nvim-treesitter/playground"] = {
    cmd = "TSCaptureUnderCursor",
    config = function()
      require("nvim-treesitter.configs").setup()
    end,
  },

  -- dim inactive windows
  ["andreadev-it/shade.nvim"] = {
    disable = true,
    opt = false,
    config = function()
      require "custom.plugins.configs.shade"
    end,
  },

  -- autosave
  ["Pocco81/auto-save.nvim"] = {
    -- opt = true,
    config = function()
      require("auto-save").setup()
    end,
  },

  -- vscode zen mode
  ["folke/zen-mode.nvim"] = {
    cmd = "ZenMode",
    config = function()
      require "custom.plugins.configs.zen-mode"
    end,
  },

  ["mfussenegger/nvim-dap"] = {
    config = function()
      require "custom.plugins.configs.dap"
    end,
  },

  ["rcarriga/nvim-dap-ui"] = {
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require "custom.plugins.configs.dap-ui"
    end,
  },

  ["theHamsta/nvim-dap-virtual-text"] = {
    config = function()
      require "custom.plugins.configs.dap-virtual-text"
    end,
  },

  ["mfussenegger/nvim-dap-python"] = {
    config = function()
      require "custom.plugins.configs.dap-python"
    end,
  },

  ["andymass/vim-matchup"] = {
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },

  ["mfussenegger/nvim-jdtls"] = {},

  ["simrat39/rust-tools.nvim"] = {
    after = "nvim-lspconfig",
    requires = { "mattn/webapi-vim" },
    config = function()
      require "custom.plugins.configs.rust-tools"
    end,
  },

  ["terryma/vim-multiple-cursors"] = {
    config = function()
      require "custom.plugins.configs.multiple-cursors"
    end,
  },

  ["jose-elias-alvarez/typescript.nvim"] = {
    config = function()
      require "custom.plugins.configs.typescript"
    end,
  },

  ["b0o/SchemaStore.nvim"] = {},
  ["Saecki/crates.nvim"] = {
    requires = { "nvim-lua/plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    config = function()
      require "custom.plugins.configs.crates"
    end,
  },

  ["brymer-meneses/grammar-guard.nvim"] = {
    requires = { "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer" },
  },

  ["p00f/clangd_extensions.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.configs.clangd_extensions"
    end,
  },

  ["rcarriga/nvim-notify"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.configs.notify"
    end,
  },

  ["jay-babu/mason-null-ls.nvim"] = {
    after = "mason.nvim",
    config = function()
      require "custom.plugins.configs.mason-null-ls"
    end,
  },
  ["folke/trouble.nvim"] = {
    requires = { "kyazdani42/nvim-web-devicons" },
    -- after = ""
    -- event = {}
    config = function()
      require "custom.plugins.configs.trouble"
    end,
  },

  ["mbbill/undotree"] = {},

  ["github/copilot.vim"] = {},
  ["jackMort/ChatGPT.nvim"] = {
    after = "telescope.nvim",
    config = function()
      require "custom.plugins.configs.chatgpt"
    end,
    requires = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },

  ["akinsho/flutter-tools.nvim"] = {
    requires = { "nvim-lua/plenary.nvim" },
    after = { "nvim-lspconfig" },
    config = function()
      require "custom.plugins.configs.flutter-tools"
    end,
  },

  ["justinj/vim-pico8-syntax"] = {},

  ["mrcjkb/haskell-tools.nvim"] = {
    after = "nvim-lspconfig",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional
    },
    config = function()
      require "custom.plugins.configs.haskell-tools"
    end,
  },
  ["akinsho/toggleterm.nvim"] = {
    config = function()
      require "custom.plugins.configs.toggleterm"
    end,
  },

  -- ["user/plugin"] = {
  --   -- requires = {}
  --   -- after = ""
  --   -- event = {}
  --   config = function ()
  --     require("custom.plugins.configs.template")
  --   end
  -- },
}
