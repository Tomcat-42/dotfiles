local undotree = require("undotree")
local map = vim.keymap.set

undotree.setup({
  float_diff = false,
  layout = "left_left_bottom",
  winblend = 0,
})

map("n", "<leader>u", undotree.toggle, { silent = true, desc = "Toggle undotree"})
