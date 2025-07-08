local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local servers = {
  "bashls",
  "clangd",
  "fish_lsp",
  "lua_ls",
  "texlab",
  "zls",
  -- "asm_lsp",
  -- "cssls",
  -- "docker_compose_language_service",
  -- "dockerls",
  -- "gitlab_ci_ls",
  -- "gitlat_ci_ls",
  -- "gopls",
  -- "html",
  -- "htmx",
  -- "jsonls",
  -- "marksman",
  -- "neocmake",
  -- "pkgbuild_language_server",
  -- "racket_langserver",
  -- "rust_analyzer",
  -- "superhtml",
  -- "systemd_ls",
  -- "ts_ls",
  -- "ty",
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
}

vim.lsp.enable(servers)
for server, config in pairs(custom_configs) do vim.lsp.config(server, config) end

autocmd("LspAttach", {
  group = augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local methods = vim.lsp.protocol.Methods
    local o = { buffer = event.buf }

    map('n', 'gr', vim.lsp.buf.references, o)
    map('n', 'gd', vim.lsp.buf.definition, o)
    map('n', 'gD', vim.lsp.buf.declaration, o)
    map('n', 'go', vim.lsp.buf.type_definition, o)
    map('n', 'gi', vim.lsp.buf.implementation, o)
    map('n', '<leader>gl', vim.diagnostic.setloclist, o)
    map('n', 'ga', vim.lsp.buf.code_action, o)
    map({ 'n', 'x' }, 'gq', vim.lsp.buf.format, o)
    map('n', 'K', function() vim.lsp.buf.hover({ border = "single" }) end, o)
    map('n', 'gs', vim.lsp.buf.signature_help, o)
    map('n', 'ra', vim.lsp.buf.rename, o)
    map('n', 'gl', vim.diagnostic.open_float, o)
    map('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, o)
    map('n', ']g', function() vim.diagnostic.jump({ count = 1 }) end, o)

    vim.diagnostic.config({
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
    })

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
      vim.lsp.inlay_hint.enable(true)
      map('n', '<leader>v', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, o)
      map("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, o)
    end

    if client and client:supports_method(methods.textDocument_completion) then
      local function feedkeys(keys)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
      end

      local function pumvisible()
        return tonumber(vim.fn.pumvisible()) ~= 0
      end

      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })

      map('i', '<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true, buffer = bufnr })
      map('i', '`', function() return pumvisible() and '<C-e>' or '/' end, { expr = true, buffer = bufnr })

      map('i', '<C-n>', function()
        if pumvisible() then
          feedkeys '<C-n>'
        else
          if next(vim.lsp.get_clients { bufnr = 0 }) then
            vim.lsp.completion.get()
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
    --     vim.lsp.buf.format()
    --     vim.lsp.buf.code_action({
    --       -- context = { only = { "source.organizeImports", "source.fixAll", }, },
    --       context = { only = { "source.organizeImports", }, },
    --       apply = true,
    --     })
    --   end
    -- })
  end,
})
