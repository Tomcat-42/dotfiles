return {
  ['mfussenegger/nvim-dap'] = {
    config = function()
      require("custom.plugins.configs.nvim-dap")
    end
  },

  ['rmagatti/goto-preview'] = {
    config = function()
      require("custom.plugins.configs.goto-preview")
    end
  },
  ['folke/which-key.nvim'] = { disable = false },
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.configs.lspconfig"
    end
  },
  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    requires = {
      { "nvim-lua/plenary.nvim" }, { "nvim-telescope/telescope-github.nvim" },
      -- {"nvim-telescope/telescope-dap.nvim"},
      { "nvim-telescope/telescope-media-files.nvim" },
      { "nvim-telescope/telescope-z.nvim" }, { "cljoly/telescope-repo.nvim" },
      { "luc-tielen/telescope_hoogle" }, { "xiyaowong/telescope-emoji.nvim" },
      { "LinArcX/telescope-command-palette.nvim" },
      { "LinArcX/telescope-env.nvim" }
    },
    config = function() require "plugins.configs.telescope" end
  },

  -- telescope extensions
  ["nvim-telescope/telescope-github.nvim"] = {},
  ["nvim-telescope/telescope-media-files.nvim"] = {},
  ["cljoly/telescope-repo.nvim"] = {},
  ["nvim-telescope/telescope-z.nvim"] = {
    config = function() require "custom.plugins.configs.telescope-z" end
  },
  ["luc-tielen/telescope_hoogle"] = {},
  ["xiyaowong/telescope-emoji.nvim"] = {},
  ["LinArcX/telescope-command-palette.nvim"] = {},
  ["LinArcX/telescope-env.nvim"] = {},
  ["kkharji/sqlite.lua"] = {},
  ["AckslD/nvim-neoclip.lua"] = {
    requires = {
      { 'kkharji/sqlite.lua', module = 'sqlite' },
      { 'nvim-telescope/telescope.nvim' }
    },
    config = function() require("custom.plugins.configs.neoclip") end
  },
  -- ["nvim-telescope/telescope-dap.nvim"] = {},
  -- ["mfussenegger/nvim-dap"] = {
  --     config = function() require("custom.plugins.configs.dap") end
  -- },

  ["Pocco81/AutoSave.nvim"] = {
    module = "autosave",
    config = function()
      require("custom.plugins.configs.smolconfigs").autosave()
    end
  },
  ["iamcco/markdown-preview.nvim"] = {},
  ["github/copilot.vim"] = {},
  ["tpope/vim-surround"] = {},
  ["karb94/neoscroll.nvim"] = {
    config = function()
      require("neoscroll").setup { mappings = { "<C-u>", "<C-d>" } }
    end
  },
  ["b0o/schemastore.nvim"] = { disable = false },
  ["mfussenegger/nvim-jdtls"] = { disable = false },
  ["goolord/alpha-nvim"] = { disable = false },
  ["windwp/nvim-ts-autotag"] = {
    ft = { "html", "javascriptreact" },
    after = "nvim-treesitter",
    config = function()
      local present, autotag = pcall(require, "nvim-ts-autotag")

      if present then autotag.setup() end
    end
  },

  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function() require "custom.plugins.configs.null-ls" end
  },

  ["Pocco81/TrueZen.nvim"] = {
    cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
    config = function() require "custom.plugins.configs.truezen" end
  },

  -- ["nvim-neorg/neorg"] = {
  --   ft = "norg",
  --   after = "nvim-treesitter",
  --   config = function() require "custom.plugins.configs.neorg" end
  -- },

  ["nvim-treesitter/playground"] = {
    cmd = "TSCaptureUnderCursor",
    config = function() require("nvim-treesitter.configs").setup() end
  },
  -- dim inactive windows
  ["andreadev-it/shade.nvim"] = {
    module = "shade",
    config = function()
      require("custom.plugins.configs.smolconfigs").shade()
    end
  },
  ["brymer-meneses/grammar-guard.nvim"] = {
    after = "nvim-lspconfig",
    disable = false,
    requires = { "neovim/nvim-lspconfig", "williamboman/nvim-lsp-installer" }
  },
  ["simrat39/rust-tools.nvim"] = {
    after = "nvim-lspconfig",
    disable = false,
    config = function() require "custom.plugins.configs.rust-tools" end
  },
  ["akinsho/flutter-tools.nvim"] = {
    after = "nvim-lspconfig",
    disable = false,
    config = function()
      require "custom.plugins.configs.flutter-tools"
    end
  },

  ["p00f/clangd_extensions.nvim"] = {
    after = "nvim-lspconfig",
    disable = false,
    config = function()
      require "custom.plugins.configs.clangd_extensions"
    end
  },
  ["frabjous/knap"] = {
    disable = false,
    config = function() require "custom.plugins.configs.knap" end
  }
}
