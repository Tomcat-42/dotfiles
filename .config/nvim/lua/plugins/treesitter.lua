local highlight = vim.api.nvim_set_hl

return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = { enable = false },
    keys = {
      { "<leader>cc", function() require('treesitter-context').toggle() end,                    "Toggle Treesitter Context" },
      { "<leader>cg", function() require('treesitter-context').go_to_context(vim.v.count1) end, "Go to Treesitter Context" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'hiphish/rainbow-delimiters.nvim',
    },
    config = function()
      highlight(0, 'TreesitterContext', { italic = true })
      require 'nvim-treesitter.configs'.setup {
        -- ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "rust", "cpp" },
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        sync_install = false,
        auto_install = true,
        indent = { enable = true },

        highlight = {
          enable = true,
          use_langtree = true,
        },
        textobjects = {
          lsp_interop = {
            enable = true,
            border = 'single',
            floating_preview_opts = {},
            peek_definition_code = {
              ["<leader>df"] = "@function.outer",
              ["<leader>dF"] = "@class.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
              ["]b"] = "@block.outer",
              ["]a"] = "@parameter.inner",
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
              ["]B"] = "@block.outer",
              ["]A"] = "@parameter.inner",
              ["]O"] = "@loop.*",
              ["]S"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
              ["]Z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[b"] = "@block.outer",
              ["[a"] = "@parameter.inner",
              ["[o"] = "@loop.*",
              ["[s"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
              ["[B"] = "@block.outer",
              ["[A"] = "@parameter.inner",
              ["[O"] = "@loop.*",
              ["[S"] = { query = "@local.scope", query_group = "locals", desc = "Previous scope" },
              ["[Z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["a/"] = "@comment.outer",
              ["i/"] = "@comment.outer",   -- no inner for comment
              ["aa"] = "@parameter.outer", -- parameter -> argument
              ["ia"] = "@parameter.inner",
              ["as"] = "@scope.outer",
              ["is"] = "@scope.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
      -- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      -- parser_config.cpp = {
      --   install_info = {
      --     url = "~/dev/tree-sitter-cpp",
      --     files = { "src/parser.c", "src/scanner.c" },
      --     branch = "feat/cpp20-modules",
      --     generate_requires_npm = false,
      --     requires_generate_from_grammar = false,
      --   },
      --   filetype = "cpp",
      -- }
    end,
  }
}
