return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufRead",
    build = ":TSUpdate",
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    config = function()
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
          enable = true, --use_langtree = true, },
          textobjects = {
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                ["]m"] = "@function.outer",
                ["gj"] = "@function.outer",
                ["]]"] = "@class.outer",
                ["]b"] = "@block.outer",
                ["]a"] = "@parameter.inner",
              },
              goto_next_end = {
                ["]M"] = "@function.outer",
                ["gJ"] = "@function.outer",
                ["]["] = "@class.outer",
                ["]B"] = "@block.outer",
                ["]A"] = "@parameter.inner",
              },
              goto_previous_start = {
                ["[m"] = "@function.outer",
                ["gk"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[b"] = "@block.outer",
                ["[a"] = "@parameter.inner",
              },
              goto_previous_end = {
                ["[M"] = "@function.outer",
                ["gK"] = "@function.outer",
                ["[]"] = "@class.outer",
                ["[B"] = "@block.outer",
                ["[A"] = "@parameter.inner",
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
      }
    end,
  }
}
