local copilot = require("copilot")

copilot.setup({
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    hide_during_completion = false,
    debounce = 75,
    trigger_on_accept = true,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-n>",
      prev = "<M-p>",
      dismiss = "<C-/>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
})
