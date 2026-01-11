local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local lsp = vim.lsp

local servers = {
  "bashls",
  "clangd",
  "fish_lsp",
  "lua_ls",
  "texlab",
  "zls",
  "ty",
  "asm_lsp",
  "rust_analyzer",
  "c3_lsp",
  "dartls",
  "yamlls",
  -- "gopls",
  -- "ts_ls",
  --"pico8_ls",
  -- "cssls",
  -- "docker_compose_language_service",
  -- "dockerls",
  -- "gitlab_ci_ls",
  -- "gitlat_ci_ls",
  -- "html",
  -- "htmx",
  -- "jsonls",
  -- "marksman",
  -- "neocmake",
  -- "pkgbuild_language_server",
  -- "racket_langserver",
  -- "superhtml",
  -- "systemd_ls",
  -- "yamlls",
  -- "ziggy",
  -- "ziggy_schema",
}

local custom_configs = {
  ["gopls"] = {
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        gofumpt = true,
      }
    }
  },
  ["clangd"] = {
    cmd = {
      "clangd",
      "--header-insertion=never",
      "--background-index",
      "--background-index-priority=normal",
      "--clang-tidy",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--rename-file-limit=0",
      "--all-scopes-completion",
      "--header-insertion-decorators",
      "--log=verbose",
      "--pch-storage=memory",
      "--offset-encoding=utf-16",
      "--fallback-style=Google",
      "--log=info",
      "--pretty",
    },
  },
  ["texlab"] = {
    settings = {
      texlab = {
        build = {
          args = { "-shell-escape", "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
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
            '--synctex-forward',
            '%l:1:%f',
            '%p',
          }
        },
      },
    },
  },
  ['*'] = {
    capabilities = {
      textDocument = {
        semanticTokens = {
          multilineTokenSupport = true,
        }
      }
    },
    root_markers = { '.git' },
  }
}

lsp.enable(servers)
for server, config in pairs(custom_configs) do lsp.config(server, config) end

-- Diagnostics
vim.diagnostic.config({
  float = { border = "single" },
  virtual_text = {
    virt_text_pos = "eol_right_align", -- 'eol'|'eol_right_align'|'inline'|'overlay'|'right_align'
    prefix = '->',                     -- '●', '▎', 'x', '■', , , ->, ' '
  },
  signs = true,
  underline = true,
})

autocmd("LspAttach", {
  group = augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local methods = lsp.protocol.Methods
    local o = { buffer = event.buf }

    -- Keymappings
    -- if client:supports_method(lsp.protocol.Methods.textDocument_references) then
    map('n', 'ge', lsp.buf.references, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_definition) then
    map('n', 'gd', lsp.buf.definition, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_declaration) then
    map('n', 'gD', lsp.buf.declaration, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_typeDefinition) then
    map('n', 'go', lsp.buf.type_definition, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_implementation) then
    map('n', 'gi', lsp.buf.implementation, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_codeAction) then
    map('n', 'ga', lsp.buf.code_action, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_formatting)
    --     or client:supports_method(lsp.protocol.Methods.textDocument_rangeFormatting) then
    map({ 'n', 'x' }, 'gq', lsp.buf.format, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_hover) then
    map('n', 'K', function() lsp.buf.hover({ border = "single" }) end, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_signatureHelp) then
    map('n', 'gs', lsp.buf.signature_help, o)
    map('i', '<C-s>', function() vim.lsp.buf.signature_help({ border = "single" }) end, o)
    -- end
    -- if client:supports_method(lsp.protocol.Methods.textDocument_rename) then
    map('n', 'gw', lsp.buf.rename, o)
    -- end

    if client:supports_method(lsp.protocol.Methods.textDocument_documentColor) then
      map({ 'n', 'x' }, 'grc', lsp.document_color.color_presentation, o)
    end
    map('n', '<leader>gl', vim.diagnostic.setloclist, o)
    map('n', 'gl', vim.diagnostic.open_float, o)
    map('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, o)
    map('n', ']g', function() vim.diagnostic.jump({ count = 1 }) end, o)

    -- Highlight
    if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = augroup('lsp-highlight', { clear = false })
      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = lsp.buf.document_highlight,
      })

      autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = lsp.buf.clear_references,
      })

      autocmd('LspDetach', {
        group = augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay Hints
    if client:supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
      lsp.inlay_hint.enable(true)
      map('n', '<leader>v', function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end, o)
      map("n", "<leader>th", function()
        lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, o)
    end

    -- Completion
    if client:supports_method(methods.textDocument_completion) then
      local function feedkeys(keys)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
      end

      local function pumvisible()
        return tonumber(vim.fn.pumvisible()) ~= 0
      end

      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars
      lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

      map('i', '<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true, buffer = bufnr })
      map('i', '`', function() return pumvisible() and '<C-e>' or '/' end, { expr = true, buffer = bufnr })

      map('i', '<C-n>', function()
        if pumvisible() then
          feedkeys '<C-n>'
        else
          if next(lsp.get_clients { bufnr = 0 }) then
            lsp.completion.get()
          else
            if vim.bo.omnifunc == '' then
              feedkeys '<C-x><C-n>'
            else
              feedkeys '<C-x><C-o>'
            end
          end
        end
      end, { desc = 'Trigger/select next completion', buffer = bufnr })

      map('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions', buffer = bufnr })

      map({ 'i', 's' }, '<Tab>', function()
        local copilot = require 'copilot.suggestion'

        if copilot.is_visible() then
          copilot.accept()
        elseif pumvisible() then
          feedkeys '<C-n>'
        elseif vim.snippet.active { direction = 1 } then
          vim.snippet.jump(1)
        else
          feedkeys '<Tab>'
        end
      end, { buffer = bufnr })

      map({ 'i', 's' }, '<S-Tab>', function()
        if pumvisible() then
          feedkeys '<C-p>'
        elseif vim.snippet.active { direction = -1 } then
          vim.snippet.jump(-1)
        else
          feedkeys '<S-Tab>'
        end
      end, { buffer = bufnr })

      map('s', '<BS>', '<C-o>s', { buffer = bufnr })
    end


    -- Auto-format on save.
    -- if not client:supports_method('textDocument/willSaveWaitUntil')
    --     and client:supports_method('textDocument/formatting') then
    --   autocmd('BufWritePre', {
    --     group = augroup('my.lsp', { clear = false }),
    --     buffer = event.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ bufnr = event.buf, id = client.id, timeout_ms = 1000 })
    --     end,
    --   })
    -- end

    -- c/cpp
    autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
      callback = function()
        map({ 'n', 'x' }, '<leader>ch', function()
          vim.cmd('LspClangdSwitchSourceHeader')
        end)

        map({ 'n', 'x' }, '<leader>ch', function()
          vim.cmd('LspClangdShowSymbolInfo')
        end)
      end
    })

    -- zig
    -- autocmd('BufWritePre', {
    --   pattern = { "*.zig", "*.zon" },
    --   callback = function()
    --     lsp.buf.format()
    --     lsp.buf.code_action({
    --       -- context = { only = { "source.organizeImports", "source.fixAll", }, },
    --       context = { only = { "source.organizeImports", }, },
    --       apply = true,
    --     })
    --   end
    -- })
  end,
})

autocmd('LspDetach', {
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    if client:supports_method(lsp.protocol.Methods.textDocument_formatting) then
      vim.api.nvim_clear_autocmds({
        event = 'BufWritePre',
        buffer = ev.buf,
      })
    end
  end,
})
