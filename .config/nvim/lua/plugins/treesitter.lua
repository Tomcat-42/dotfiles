local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
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

  incremental_selection = {
    enable = true,
    keymaps = {
      node_incremental = "v",
      node_decremental = "V",
    },
  },

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
