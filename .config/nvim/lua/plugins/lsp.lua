local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd

return {
  { 'f3fora/nvim-texlabconfig', ft = { 'tex', 'bib' }, build = 'go build -o ~/.local/bin/' },
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

      -- Default:
      --
      --['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      --['<C-e>'] = { 'hide' },
      --['<C-y>'] = { 'select_and_accept' },
      --
      --['<C-p>'] = { 'select_prev', 'fallback' },
      --['<C-n>'] = { 'select_next', 'fallback' },
      --
      --['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      --['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      --
      --['<Tab>'] = { 'snippet_forward', 'fallback' },
      --['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      keymap = {
        preset = 'default',
        ["<c-g>"] = {
          function()
            require("blink-cmp").show({ sources = { "ripgrep" } })
          end,
        },
        ['<c-s>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
        ["<c-k>"] = {
          function()
            require("blink-cmp").show()
          end,
        },
        ["<c-c>"] = {
          function()
            require("blink-cmp").show({ sources = { "copilot" } })
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
      completion = {
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        trigger = {
          prefetch_on_insert                  = true,
          show_on_keyword                     = true,
          show_on_trigger_character           = true,
          show_on_accept_on_trigger_character = true,
          show_on_insert_on_trigger_character = true,
        },
        menu = {
          draw = {
            columns = {
              { "label",     "label_description", gap = 1 },
              { "kind_icon", "kind" }
            },
          },
          auto_show = true,
          border = 'single'
        },
        documentation = {
          auto_show = true,
          window = { border = 'single' }
        },

        ghost_text = { enabled = true },
      },
      signature = {
        enabled = true,
        window = { border = "single" }
      },
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
            "--header-insertion=iwyu",
            "--header-insertion=never",
            "--clang-tidy",
            "--clang-tidy-checks=*",
            "--completion-style=detailed",
            "--all-scopes-completion",
            "--cross-file-rename",
            "--fallback-style=Google",
            "--header-insertion-decorators",
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

      autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local o = { buffer = event.buf }

          map({ 'n', 'x' }, 'gq', vim.lsp.buf.format, o)
          map('n', 'K', vim.lsp.buf.hover, o)
          map('n', 'gd', vim.lsp.buf.definition, o)
          map('n', 'gD', vim.lsp.buf.declaration, o)
          map('n', 'gi', vim.lsp.buf.implementation, o)
          map('n', 'go', vim.lsp.buf.type_definition, o)
          map('n', 'gr', vim.lsp.buf.references, o)
          map('n', 'gs', vim.lsp.buf.signature_help, o)
          map('n', 'ra', vim.lsp.buf.rename, o)
          map('n', 'ga', vim.lsp.buf.code_action, o)
          map('n', '<leader>gl', vim.diagnostic.setloclist, o)
          map('n', 'gl', vim.diagnostic.open_float, o)
          map('n', '[g', vim.diagnostic.goto_prev, o)
          map('n', ']g', vim.diagnostic.goto_next, o)

          vim.lsp.inlay_hint.enable(true)

          map('n', '<leader>v', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, o)

          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
              border = "single"
            }
          )

          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
              border = "single"
            }
          )

          vim.diagnostic.config {
            -- virtual_lines = true,
            virtual_text = {
              virt_text_pos = "eol_right_align",
              prefix = '■ ', -- '●', '▎', 'x', '■', , 
              enabled = true,
            },
            float = { border = "single" }
          }
        end,
      })


      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      lspconfig.glsl_analyzer.setup {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        on_attach = function(client, bufnr)
          if client.name == "glsl_analyzer" then
            client.cancel_request = function(_, _) end
          end
        end
      }


      autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
        callback = function()
          vim.keymap.set({ 'n', 'x' }, '<leader>gh', function()
            vim.cmd('ClangdSwitchSourceHeader')
          end)
        end
      })


      -- autocmd('BufWritePre', {
      --   pattern = { "*.zig", "*.zon" },
      --   callback = function()
      --     vim.lsp.buf.format()
      --     vim.lsp.buf.code_action({
      --       -- context = { only = { "source.organizeImports", "source.fixAll", }, },
      --       context = { only = { "source.organizeImports", }, },
      --       apply = true,
      --     })
      --   end
      -- })

      autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.tex", "*.bibtex" },
        callback = function()
          require('texlabconfig').setup({
            cache_activate = true,
            cache_filetypes = { 'tex', 'bib' },
            cache_root = vim.fn.stdpath('cache'),
            reverse_search_start_cmd = function()
              return true
            end,
            reverse_search_edit_cmd = vim.cmd.edit,
            reverse_search_end_cmd = function()
              return true
            end,
            file_permission_mode = 438,
          })
          map('n', '<leader>lf', '<cmd>TexlabForward<cr>', { silent = true, noremap = true })
          map('n', '<leader>lb', '<cmd>TexlabBuild<cr>', { silent = true, noremap = true })
        end,
      })
    end
  }
}
