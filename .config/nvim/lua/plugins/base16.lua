local hl = vim.api.nvim_set_hl

require("mini.base16").setup({
  palette = {
    base00 = "#000000",
    base01 = "#000000",
    base02 = "#1d2021",
    base03 = "#665c54",
    base04 = "#bdae93",
    base05 = "#d5c4a1",
    base06 = "#ebdbb2",
    base07 = "#fbf1c7",
    base08 = "#fb4934",
    base09 = "#fe8019",
    base0A = "#fabd2f",
    base0B = "#98971a",
    base0C = "#8ec07c",
    base0D = "#83a598",
    base0E = "#d3869b",
    base0F = "#d65d0e",
  },
  use_cterm = true,
  plugins = { default = true },
})

hl(0, "VertSplit", { fg = "#665c54" })
hl(0, "WinSeparator", { fg = "#665c54" })
hl(0, "ColorColumn", { link = "Visual" })
hl(0, "CursorLine", { bg = "NONE" })

hl(0, "@comment.todo", { fg = "#fabd2f", bold = true })
hl(0, "@comment.error", { fg = "#fb4934", bold = true })
hl(0, "@comment.fixme", { fg = "#d65d0e", bold = true })
hl(0, "@comment.warning", { fg = "#fe8019", bold = true })
hl(0, "@comment.hack", { fg = "#d3869b", bold = true })
hl(0, "@comment.xxx", { fg = "#8ec07c", bold = true })
hl(0, "@comment.note", { fg = "#83a598", bold = true })
