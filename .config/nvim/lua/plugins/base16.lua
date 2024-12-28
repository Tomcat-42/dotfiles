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
          base02 = '#4b6988', -- Selection Background
          base03 = '#55799c', -- Comments, Invisibles, Line Highlighting
          base04 = '#ffffff', -- Dark Foreground (Status Line)
          base05 = '#ffffff', -- Foreground / Default Text
          base06 = '#ffffff', -- Light Foreground (Not often used)
          base07 = '#ffffff', -- Light Background (Not often used)
          base08 = '#ff6666', -- Red
          base09 = '#ff9966', -- Orange
          base0A = '#ffff66', -- Yellow
          base0B = '#66ff66', -- Green
          base0C = '#4b8f77', -- Cyan
          base0D = '#15f4ee', -- Blue
          base0E = '#9c6cd3', -- Purple
          base0F = '#bb64a9', -- Magenta
        },
        use_cterm = true,
        plugins = {
          default = true
        },
      })
      vim.api.nvim_set_hl(0, 'VertSplit', { fg = "#55799c", bg = nil, attr = nil, sp = nil })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#55799c", bg = nil, attr = nil, sp = nil })
    end
  }
}
