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
