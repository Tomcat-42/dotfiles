local diff = require("mini.diff")
diff.setup()
vim.keymap.set('n', '<leader>go', diff.toggle_overlay, { silent = true, desc = 'Toggle diff overlay' })
