return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100,
        },
      },
    },
    keys = {
      { "<leader>ff", '<cmd>lua require("fzf-lua").files()<cr>',               desc = "Find Files" },
      { "<leader>fw", '<cmd>lua require("fzf-lua").live_grep_native()<cr>',    desc = "Find Words" },
      { "<leader>fb", '<cmd>lua require("fzf-lua").buffers()<cr>',             desc = "Find Buffers" },
      { "<leader>fh", '<cmd>lua require("fzf-lua").help_tags()<cr>', desc = "Find Help Tags" },
    },
  }
}
