local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

return {
  -- when https://github.com/neovim/nvim-lspconfig/issues/3705 (Some configs are not ported yet)
  -- do the new config format: https://github.com/neovim/nvim-lspconfig
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
    dependencies = {
      "ibhagwan/fzf-lua",
      "saghen/blink.cmp",
    },
    opts = {
      servers = {
        html = {},
        cssls = {},
        yamlls = {},
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
            "--enable-config",
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
        },
        asm_lsp = {},
        glsl_analyzer = {
        },
      }
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do lspconfig[server].setup(config) end

      autocmd('LspAttach', {
        desc = 'LSP actions',
        group = augroup('lsp', { clear = true }),
        callback = function(event)
          local o = { buffer = event.buf }
          local fzf = require('fzf-lua')
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- map('n', 'gr', vim.lsp.buf.references, o)
          -- map('n', 'gd', vim.lsp.buf.definition, o)
          -- map('n', 'gD', vim.lsp.buf.declaration, o)
          -- map('n', 'go', vim.lsp.buf.type_definition, o)
          -- map('n', 'gi', vim.lsp.buf.implementation, o)
          -- map('n', '<leader>gl', vim.diagnostic.setloclist, o)
          -- map('n', 'ga', vim.lsp.buf.code_action, o)
          map('n', 'gr', fzf.lsp_references, o)
          map('n', 'gd', fzf.lsp_definitions, o)
          map('n', 'gD', fzf.lsp_declarations, o)
          map('n', 'go', fzf.lsp_typedefs, o)
          map('n', 'gi', fzf.lsp_implementations, o)
          map('n', 'gS', fzf.lsp_document_symbols, o)
          map('n', 'gW', fzf.lsp_workspace_symbols, o)
          map('n', 'ga', fzf.lsp_code_actions, o)
          map('n', 'gF', fzf.lsp_finder, o)
          map('n', '<leader>gl', fzf.diagnostics_document, o)
          map('n', '<leader>gw', fzf.diagnostics_workspace, o)

          map({ 'n', 'x' }, 'gq', vim.lsp.buf.format, o)
          map('n', 'K', function() vim.lsp.buf.hover({ border = "single" }) end, o)
          map('n', 'gs', vim.lsp.buf.signature_help, o)
          map('n', 'ra', vim.lsp.buf.rename, o)
          map('n', 'gl', vim.diagnostic.open_float, o)
          map('n', '[g', vim.diagnostic.goto_prev, o)
          map('n', ']g', vim.diagnostic.goto_next, o)

          vim.lsp.inlay_hint.enable(true)

          map('n', '<leader>v', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, o)

          vim.diagnostic.config {
            -- virtual_lines = {
            --   enabled = true,
            --   current_line = true,
            -- },
            -- signs = {
            --   text = {
            --     ERROR = '',
            --     WARN = '',
            --     INFO = '',
            --     HINT = '',
            --   }
            -- },
            virtual_text = {
              virt_text_pos = "eol_right_align", -- 'eol'|'eol_right_align'|'inline'|'overlay'|'right_align'
              prefix = ' ', -- '●', '▎', 'x', '■', , , ->
              enabled = true,
            },
            float = { border = "single" }
          }

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("n", "<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, o)
          end
        end,
      })

      autocmd({ "BufEnter", "BufWinEnter" }, {
        pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
        callback = function()
          vim.keymap.set({ 'n', 'x' }, '<leader>ch', function()
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
  },
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
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
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
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'buffer',
          'snippets',
          -- "ripgrep",
          "copilot"
        },
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
      cmdline = {
        enabled = false,
        sources = {},
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          }
        },
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
            treesitter = { "lsp" },
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
  -- { 'f3fora/nvim-texlabconfig', ft = { 'tex', 'bib' }, build = 'go build -o ~/.local/bin/' },
  -- {
  --   "p00f/clangd_extensions.nvim",
  --   ft = { "c", "cpp" },
  --   keys = {
  --     { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source Header" },
  --     { "<leader>ca", "<cmd>ClangdAST<cr>",                desc = "Clangd AST",           mode = { "n", "v" } },
  --     { "<leader>cs", "<cmd>ClangdSymbolInfo<cr>",         desc = "Clangd Symbol Info" },
  --     { "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>",      desc = "Clangd Type Hierarchy" },
  --     { "<leader>cm", "<cmd>ClangdMemoryUsage<cr>",        desc = "Clangd Memory Usage" },
  --   },
  -- },
  -- {
  --   'lewis6991/gitsigns.nvim',
  --   keys = {
  --     { '<leader>gg', function() require('gitsigns').toggle_signs() end, desc = 'Toggle Gitsigns' },
  --   },
  --   opts = {
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '~' },
  --       delete = { text = '_' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '~' },
  --     },
  --   },
  -- },
}
