return {
  {
    "echasnovski/mini.base16",
    lazy = false,
    priority = 1000,
    config = function()
      require("mini.base16").setup({
        palette = {
          base00 = '#000000', -- Default Background
          base01 = '#000000', -- Darker Background (Status Line, etc.)
          base02 = '#1d2021', -- Selection Background
          base03 = '#665c54', -- Comments, Invisibles, Line Highlighting
          base04 = '#bdae93', -- Dark Foreground (Status Line)
          base05 = '#d5c4a1', -- Foreground / Default Text
          base06 = '#ebdbb2', -- Light Foreground (Not often used)
          base07 = '#fbf1c7', -- Light Background (Not often used)
          base08 = '#fb4934', -- Red
          base09 = '#fe8019', -- Orange
          base0A = '#fabd2f', -- Yellow
          base0B = '#98971a', -- Green
          base0C = '#8ec07c', -- Cyan
          base0D = '#83a598', -- Blue
          base0E = '#d3869b', -- Purple
          base0F = '#d65d0e', -- Magenta
        },
        use_cterm = true,
        plugins = {
          default = true
        },
      })
      vim.api.nvim_set_hl(0, 'VertSplit', { fg = "#665c54", bg = nil, attr = nil, sp = nil })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#665c54", bg = nil, attr = nil, sp = nil })
      vim.api.nvim_set_hl(0, 'ColorColumn', { link = "Visual" })
      vim.api.nvim_set_hl(0, 'CursorLine', { link = "Visual" })
    end
  }
}
