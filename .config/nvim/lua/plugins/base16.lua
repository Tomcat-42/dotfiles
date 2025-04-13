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
          base02 = '#191724', -- Selection Background
          base03 = '#7c6f64', -- Comments, Invisibles, Line Highlighting
          base04 = '#c4a7e7', -- Dark Foreground (Status Line)
          base05 = '#f5e0dc', -- Foreground / Default Text
          base06 = '#e0def4', -- Light Foreground (Not often used)
          base07 = '#f2e9e1', -- Light Background (Not often used)
          base08 = '#eb6f92', -- Red
          base09 = '#f6c177', -- Orange
          base0A = '#f6c177', -- Yellow
          base0B = '#31748f', -- Green
          base0C = '#9ccfd8', -- Cyan
          base0D = '#c4a7e7', -- Blue
          base0E = '#f6c177', -- Purple
          base0F = '#eb6f92', -- Magenta
        },
        use_cterm = true,
        plugins = {
          default = true
        },
      })
      vim.api.nvim_set_hl(0, 'VertSplit', { fg = "#7c6f64", bg = nil, attr = nil, sp = nil })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = "#7c6f64", bg = nil, attr = nil, sp = nil })
      vim.api.nvim_set_hl(0, 'ColorColumn', { link = "Visual" })
      vim.api.nvim_set_hl(0, 'CursorLine', { link = "Visual" })
    end
  }
}
