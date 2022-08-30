local M = {}

local override = require "custom.override"

M.plugins = {
    options = {
        statusline = {separator_style = "round"}
    },

    override = {
        ["kyazdani42/nvim-tree.lua"] = override.nvimtree,
        ["nvim-treesitter/nvim-treesitter"] = override.treesitter,
        ["lukas-reineke/indent-blankline.nvim"] = override.blankline,
        ["nvim-telescope/telescope.nvim"] = override.telescope
    },

    user = require "custom.plugins",

    remove = {}
}

M.ui = {
    theme = "tokyonight",
    hl_override = require "custom.highlights",
    transparency = true
}

M.mappings = require "custom.mappings"

-- options

return M
