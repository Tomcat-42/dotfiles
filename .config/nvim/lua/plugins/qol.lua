return {
  {
    "stevearc/oil.nvim",
    opts = { view_options = { show_hidden = true } },
    cmd = {
      "Oil"
    },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer" }
    },
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>gq",
        function() require("conform").format({ async = true }) end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        shtml = { 'superhtml' },
        ziggy = { 'ziggy' },
        ziggy_schema = { 'ziggy_schema' },
      },
      default_format_opts = { lsp_format = "fallback" },
      formatters = {
        superhtml = {
          inherit = false,
          command = 'superhtml',
          stdin = true,
          args = { 'fmt', '--stdin-super' },
        },
        ziggy = {
          inherit = false,
          command = 'ziggy',
          stdin = true,
          args = { 'fmt', '--stdin' },
        },
        ziggy_schema = {
          inherit = false,
          command = 'ziggy',
          stdin = true,
          args = { 'fmt', '--stdin-schema' },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "jiaoshijie/undotree",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      float_diff = false,
      layout = "left_left_bottom", -- "left_bottom", "left_left_bottom"
      winblend = 0,
    },
    keys = { { "<leader>u", function() require('undotree').toggle() end, desc = "Toggle UndoTree" } },
  },
  {
    "ibhagwan/fzf-lua",
    opts = { { "telescope", "max-perf", "ivy" } },
    keys = {
      { "<leader>ff", '<cmd>lua require("fzf-lua").files()<cr>',            desc = "Find Files" },
      { "<leader>fw", '<cmd>lua require("fzf-lua").live_grep_native()<cr>', desc = "Find Words" },
      { "<leader>fb", '<cmd>lua require("fzf-lua").buffers()<cr>',          desc = "Find Buffers" },
      { "<leader>fh", '<cmd>lua require("fzf-lua").help_tags()<cr>',        desc = "Find Help Tags" },
      { "<leader>fm", '<cmd>lua require("fzf-lua").marks()<cr>',            desc = "Find Marks" },
      { "<leader>fl", '<cmd>lua require("fzf-lua").manpages()<cr>',         desc = "Find Marks" },
      { "<leader>fc", '<cmd>lua require("fzf-lua").commands()<cr>',         desc = "Find Marks" },
      { "<leader>fs", '<cmd>lua require("fzf-lua").command_history()<cr>',  desc = "Find Marks" },
    },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
  }
}
