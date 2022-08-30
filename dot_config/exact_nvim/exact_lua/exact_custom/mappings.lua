local M = {}

--
-- M.disabled = {
--    "<C-n>",
-- }

M.telescope = {
    n = {
        ["<leader>fp"] = {"<cmd>Telescope media_files <CR>", "  find media"},
        ["<leader>tg"] = {"<cmd>Telescope gh gist <CR>", " find gist"},
        ["<leader>tr"] = {
            "<cmd>Telescope repo list <CR>", " find repos in the system"
        },

        ["<leader>to"] = {"<cmd>Telescope hoogle <CR>", " haskell hoogle"},

        ["<leader>te"] = {"<cmd>Telescope emoji <CR>", " find emoji"},

        ["<leader>tc"] = {
            "<cmd>Telescope command_palette <CR>", " command palette"
        },

        ["<leader>tv"] = {"<cmd>Telescope env <CR>", " environment vars"},
        ["<leader>ty"] = {"<cmd>Telescope neoclip <CR>", "neoclip"}
    }
}

M.truzen = {
    n = {
        ["<leader>ta"] = {"<cmd> TZAtaraxis <CR>", "   truzen ataraxis"},
        ["<leader>tm"] = {"<cmd> TZMinimalist <CR>", "   truzen minimal"},
        ["<leader>tf"] = {"<cmd> TZFocus <CR>", "   truzen focus"}
    }
}

M.treesitter = {
    n = {
        ["<leader>cu"] = {"<cmd> TSCaptureUnderCursor <CR>", "  find media"}
    }
}

M.shade = {
    n = {
        ["<leader>s"] = {
            function() require("shade").toggle() end, "   toggle shade.nvim"
        }
    }
}

M.copilot = {
    i = {
        ["<C-j>"] = {
            'copilot#Accept("<CR>")',
            "ﮧ  copilot completion",
            opts = {silent = true, script = true, expr = true}
        }
    }
}

M.general = {
    n = {
        ["<ESC>"] = {"<cmd> noh <CR>", "Remove Highlights"},
        ["<leader>fm"] = {
            function() vim.lsp.buf.formatting() end, "   lsp formatting"
        }
    }
}

M.knap = {
    i = {
        ["<F5>"] = {
            function() require("knap").process_once() end,
            "   knap process once"
        },
        ["<F6>"] = {
            function() require("knap").close_viewer() end,
            "   knap close viewer"
        },
        ["<F7>"] = {
            function() require("knap").toggle_autopreviewing() end,
            "  knap toggle autopreviewing"
        },
        ["<F8>"] = {
            function() require("knap").forward_jump() end,
            "  knap forward jump"
        }
    },
    v = {
        ["<F5>"] = {
            function() require("knap").process_once() end,
            "   knap process once"
        },
        ["<F6>"] = {
            function() require("knap").close_viewer() end,
            "   knap close viewer"
        },
        ["<F7>"] = {
            function() require("knap").toggle_autopreviewing() end,
            "  knap toggle autopreviewing"
        },
        ["<F8>"] = {
            function() require("knap").forward_jump() end,
            "  knap forward jump"
        }
    },
    n = {
        ["<F5>"] = {
            function() require("knap").process_once() end,
            "   knap process once"
        },
        ["<F6>"] = {
            function() require("knap").close_viewer() end,
            "   knap close viewer"
        },
        ["<F7>"] = {
            function() require("knap").toggle_autopreviewing() end,
            "  knap toggle autopreviewing"
        },
        ["<F8>"] = {
            function() require("knap").forward_jump() end,
            "  knap forward jump"
        }
    }
}

M.clangd = {
    n = {
        ["<leader>ch"] = {
            "<cmd> ClangdSwitchSourceHeader <CR>",
            "   clangd switch source header"
        }
    }
}

return M
