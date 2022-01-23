-- MAPPINGcope p
local map = require("core.utils").map

map("n", "<leader>zz", ":TZAtaraxis<cr>")
map("n", "<leader>zf", ":TZFocus<cr>")
map("n", "<leader>zm", ":TZMinimalist<cr>")
map("n", "<leader>tp", ":lua require'telescope'.load_extension('project')<cr>")
map("o", "m", ":<C-U>lua require('tsht').nodes()<CR>")
map("n", "m", ":lua require('tsht').nodes()<CR>")


local customPlugins = require "core.customPlugins"

customPlugins.add(function(use)
   use {
      "pwntester/octo.nvim",
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
        'kyazdani42/nvim-web-devicons',
      },
      config = function()
         require("custom.plugins.octo").setup()
      end,
   }

   use {
      "nvim-telescope/telescope-project.nvim",
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
      },
   }
  -- use {
  --   "SmiteshP/nvim-gps",
  --   requires = "nvim-treesitter/nvim-treesitter",
  --   after = "nvim-treesitter",
  --   config = function()
  --        require "custom.plugins.gps"
  --   end,
  --   opt = true
  -- }

  use {
    'lewis6991/spellsitter.nvim',
    requires = "nvim-treesitter/nvim-treesitter",
    after = "nvim-treesitter",
    config = function()
         require "custom.plugins.spellsitter"
    end
  }

  use {
    "folke/twilight.nvim",
    config = function()
         require "custom.plugins.twilight"
    end
  }
   use {
     "p00f/nvim-ts-rainbow",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
   }

   use {
     "mfussenegger/nvim-treehopper",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
         require "custom.plugins.treehopper"
      end
   }

   use {
     "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
   }

   use {
     "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
   }

   use { 
    "nvim-treesitter/nvim-treesitter-refactor",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
    }

   use { 
    "romgrk/nvim-treesitter-context",
      after = "nvim-treesitter",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
         require "custom.plugins.treesitter-context"
      end,
    }

   use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",

      config = function()
         require "custom.plugins.todo_comments"
      end,
   }

   use {
      "folke/trouble.nvim",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
         require "custom.plugins.trouble"
      end,
   }

   use { "nathom/filetype.nvim" }

   -- use {
   --    "williamboman/nvim-lsp-installer",
   --     after = "nvim-lspconfig",
   --     config = function()
   --        require("custom.plugins.lspinstaller").setup()
   --     end,
   -- }

   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.null-ls").setup()
      end,
   }

   -- use {
   --    "akinsho/flutter-tools.nvim",
   --    requires = "nvim-lua/plenary.nvim",
   --    config = function()
   --       require("flutter-tools").setup {}
   --       require("telescope").load_extension "flutter"
   --    end,
   -- }

   use {
      "karb94/neoscroll.nvim",
      opt = true,
      config = function()
         require("neoscroll").setup()
      end,

      -- lazy loading
      setup = function()
         require("core.utils").packer_lazy_load "neoscroll.nvim"
      end,
   }
   use {
      "Pocco81/AutoSave.nvim",
      config = function()
         local autosave = require "autosave"

         autosave.setup {
            enabled = true,
            execution_message = "autosaved at : " .. vim.fn.strftime "%H:%M:%S",
            events = { "InsertLeave", "TextChanged" },
            conditions = {
               exists = true,
               filetype_is_not = {},
               modifiable = true,
            },
            clean_command_line_interval = 2500,
            on_off_commands = true,
            write_all_buffers = false,
         }
      end,
   }
   use {
      "Pocco81/TrueZen.nvim",
      cmd = { "TZAtaraxis", "TZMinimalist", "TZFocus" },
      config = function()
         local true_zen = require "true-zen"
         true_zen.setup {}
      end,
   }

   -- use {
   --    "nvim-telescope/telescope-github.nvim",
   --    requires = "nvim-lua/plenary.nvim",
   --    config = function()
   --       require("telescope").load_extension "gh"
   --    end,
   -- }
end)
