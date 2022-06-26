return {
  ["iamcco/markdown-preview.nvim"] = {},
  ["github/copilot.vim"] = {},
  ["tpope/vim-surround"] = {},
  ["karb94/neoscroll.nvim"] = {
    config = function()
      require("neoscroll").setup {
        mappings = { "<C-u>", "<C-d>" },
      }
    end,
  },
   ["p00f/clangd_extensions.nvim"] = {
      config = function()
         require "custom.plugins.clangd_extensions"
      end,
   },
   ["brymer-meneses/grammar-guard.nvim"] = {
      disable = false,
      requires = {
        "neovim/nvim-lspconfig",
        "williamboman/nvim-lsp-installer"
      },
   },
   ["b0o/schemastore.nvim"] = {
      disable = false,
   },
   ["simrat39/rust-tools.nvim"] = {
      disable = false,
      config = function()
         require "custom.plugins.rust-tools"
      end,
   },
   ["akinsho/flutter-tools.nvim"] = {
      disable = false,
      config = function()
         require "custom.plugins.flutter-tools"
      end,
   },
   ["mfussenegger/nvim-jdtls"] = {
      disable = false,
   },
   ["goolord/alpha-nvim"] = {
      disable = false,
   },
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

   ["jose-elias-alvarez/null-ls.nvim"] = {
      after = "nvim-lspconfig",
      config = function()
         require "custom.plugins.null-ls"
      end,
   },

   ["Pocco81/TrueZen.nvim"] = {
      cmd = {
         "TZAtaraxis",
         "TZMinimalist",
         "TZFocus",
      },
      config = function()
         require "custom.plugins.truezen"
      end,
   },

   ["nvim-neorg/neorg"] = {
      ft = "norg",
      after = "nvim-treesitter",
      config = function()
         require "custom.plugins.neorg"
      end,
   },

   ["nvim-treesitter/playground"] = {
      cmd = "TSCaptureUnderCursor",
      config = function()
         require("nvim-treesitter.configs").setup()
      end,
   },

   ["andreadev-it/shade.nvim"] = {
      module = "shade",
      config = function()
         require("shade").setup {
            overlay_opacity = 50,
            opacity_step = 1,
            exclude_filetypes = { "NvimTree" },
         }
      end,
   },
}
