-- overriding default plugin configs!

local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "html",
    "css",
    "javascript",
    "json",
    "toml",
    "markdown",
    "c",
    "bash",
    "lua",
    "norg",
    "tsx",
    "typescript",
    "rust",
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true,
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = true,
    },
    highlight_current_scope = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",
          list_definitions = "gnD",
          list_definitions_toc = "gO",
          goto_next_usage = "<a-*>",
          goto_previous_usage = "<a-#>",
        },
      },
    },
  },
  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    disable = { "c", "ruby" }, -- optional, list of language that will be disabled
    -- [options]
  },
}

M.nvimtree = {
  filters = {
    dotfiles = true,
    custom = { "node_modules" },
  },

  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.blankline = {
  filetype_exclude = {
    "help",
    "terminal",
    "alpha",
    "packer",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "nvchad_cheatsheet",
    "lsp-installer",
    "norg",
    "",
  },
}

M.alpha = {
  header = {
    val = {
      "                 |   _    /   _ |_) \\/|_  _  __ _ ",
      "                 |__(_|   \\__(_||   / |_)(_| | (_|",
      "                                                   ",
      "                                                   ",
      "                                 .;o,",
      '            __."iIoi,._              ;pI __-"-xx.,_',
      "          `.3\"P3PPPoie-,.            .d' `;.     `p;",
      '         `O"dP"````""`PdEe._       .;\'   .     `  `|   OK I PULL UP',
      '        "$#"\'            ``"P4rdddsP\'  .F.    ` `` ;  /',
      '       i/"""     *"Sp.               .dPff.  _.,;Gw\'',
      '       ;l"\'     "  `dp..            "sWf;fe|\'',
      '      `l;          .rPi .    . "" "dW;;doe;',
      '       $          .;PE`\'       " "sW;.d.d;',
      '       $$        .$"`     `"saed;lW;.d.d.i',
      "       .$M       ;              ``  ' ld;.p.",
      "    __ _`$o,.-__  \"ei-Mu~,.__ ___ `_-dee3'o-ii~m. ____",
    },
  },
}

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    -- "emmet-ls",
    "json-lsp",
    "tailwindcss-language-server",

    -- shell
    "shfmt",
    "shellcheck",
  },
}

M.ui = {
  statusline = {
    separator_style = "block", -- default/round/block/arrow
    overriden_modules = nil,
  },
  -- lazyload it when there are 1+ buffers
  tabufline = {
    enabled = true,
    lazyload = true,
    overriden_modules = nil,
  },
}

M.telescope = {
  extensions_list = { "themes", "terms", "ui-select", "flutter" },
  -- extensions = {
  --   ["ui-select"] = {
  --     require("telescope.themes").get_dropdown {
  --       -- even more opts
  --     },
  --   },
  -- },
}

return M
