return {
  {
    'saghen/blink.cmp',
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
      "giuxtaposition/blink-cmp-copilot",
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
        },
      },
    },
    build = 'cargo build --release',
    opts = {
      keymap = {
        preset = 'default',
        ["<c-g>"] = {
          function()
            require("blink-cmp").show({ sources = { "ripgrep" } })
          end,
        },
      },
      appearance = { use_nvim_cmp_as_default = false, nerd_font_variant = 'mono' },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          -- "ripgrep",
          "copilot"
        },
        cmdline = {},
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            opts = {
              prefix_min_len = 3,
              context_size = 5,
              max_filesize = "1M",
              search_casing = "--ignore-case",
              additional_rg_options = {},
            },
          },
        },

      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" }
  },
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    cmd = {
      "LspInfo",
      "LspInstall",
      "LspUninstall",
      "LspStart"
    },
    dependencies = { "saghen/blink.cmp" },
    opts = {
      servers = {
        html = {},
        cssls = {},
        ts_ls = {},
        pyright = {},
        arduino_language_server = {},
        glsl_analyzer = {},
        bashls = {},
        taplo = {},
        fortls = {},
        lua_ls = {},
        rust_analyzer = {},
        gopls = {},
        jsonls = {},
        cmake = {},
        zls = {},
        fish_lsp = {},
        jdtls = {},
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            -- "--header-insertion=iwyu",
            "--header-insertion=never",
            "--clang-tidy",
            "--clang-tidy-checks=*",
            "--completion-style=detailed",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--fallback-style=Google",
            "--header-insertion-decorators",
            -- "--experimental-modules-support",
            "--log=verbose",
            "--pch-storage=memory",
            "--offset-encoding=utf-16",
          },
        },
        texlab = {
          settings = {
            texlab = {
              build = {
                args = { "-shell-escape", "-pdf", "-pv", "-interaction=nonstopmode", "-synctex=1", "%f" },
                executable = "latexmk",
                forwardSearchAfter = true,
                onSave = true
              },
              chktex = {
                onEdit = false,
                onOpenAndSave = true,
              },
              forwardSearch = {
                executable = "zathura",
                args = {
                  '--synctex-editor-command',
                  [[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] ..
                  vim.v.servername,
                  '--synctex-forward',
                  '%l:1:%f',
                  '%p',
                }
              },
            },
          },
        }
      },
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')

      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local map = vim.keymap.set
          local opts = { buffer = event.buf }

          map({ 'n', 'x' }, 'gq', vim.lsp.buf.format, opts)
          map('n', 'K', vim.lsp.buf.hover, opts)
          map('n', 'gd', vim.lsp.buf.definition, opts)
          map('n', 'gD', vim.lsp.buf.declaration, opts)
          map('n', 'gi', vim.lsp.buf.implementation, opts)
          map('n', 'go', vim.lsp.buf.type_definition, opts)
          map('n', 'gr', vim.lsp.buf.references, opts)
          map('n', 'gs', vim.lsp.buf.signature_help, opts)
          map('n', 'gr', vim.lsp.buf.rename, opts)
          map('n', 'ga', vim.lsp.buf.code_action, opts)
          map('n', 'gl', vim.diagnostic.setloclist)

          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

          -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
          --   pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
          --   callback = function()
          --     vim.keymap.set({ 'n', 'x' }, '<leader>gh', function()
          --       vim.cmd('ClangdSwitchSourceHeader')
          --     end, opts)
          --   end
          -- })

          -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
          --   pattern = { "*.tex", "*.bibtex" },
          --   callback = function()
          --     require('texlabconfig').setup({
          --       cache_activate = true,
          --       cache_filetypes = { 'tex', 'bib' },
          --       cache_root = vim.fn.stdpath('cache'),
          --       reverse_search_start_cmd = function()
          --         return true
          --       end,
          --       reverse_search_edit_cmd = vim.cmd.edit,
          --       reverse_search_end_cmd = function()
          --         return true
          --       end,
          --       file_permission_mode = 438,
          --     })
          --     map('n', '<leader>lf', '<cmd>TexlabForward<cr>', { silent = true, noremap = true })
          --     map('n', '<leader>lb', '<cmd>TexlabBuild<cr>', { silent = true, noremap = true })
          --   end,
          --   opts
          -- })
        end,
      })

      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end
  }
}
