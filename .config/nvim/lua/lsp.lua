local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local lsp = vim.lsp

local servers = {
  "asm_lsp",
  "bashls",
  "clangd",
  "fish_lsp",
  "gopls",
  "lua_ls",
  "rust_analyzer",
  "texlab",
  "ty",
  "yamlls",
  "zls",
  "rpmspec",
}

local custom_configs = {
  ["gopls"] = {
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = { unusedparams = true },
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
      "--pch-storage=memory",
      "--offset-encoding=utf-16",
      "--fallback-style=Google",
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
          onSave = true,
        },
        chktex = {
          onEdit = false,
          onOpenAndSave = true,
        },
        forwardSearch = {
          executable = "zathura",
          args = { '--synctex-forward', '%l:1:%f', '%p' },
        },
      },
    },
  },
  ['*'] = {
    capabilities = {
      textDocument = {
        semanticTokens = { multilineTokenSupport = true },
      }
    },
    root_markers = { '.git' },
  }
}

lsp.enable(servers)
for server, config in pairs(custom_configs) do lsp.config(server, config) end

vim.diagnostic.config({
  float = { border = "single" },
  virtual_text = {
    virt_text_pos = "eol_right_align",
    prefix = '->',
  },
  signs = true,
  underline = true,
  severity_sort = true,
})

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

autocmd("LspAttach", {
  group = augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = assert(lsp.get_client_by_id(event.data.client_id))
    local o = { buffer = bufnr }

    map('n', 'ge', lsp.buf.references, o)
    map('n', 'gd', lsp.buf.definition, o)
    map('n', 'gD', lsp.buf.declaration, o)
    map('n', 'go', lsp.buf.type_definition, o)
    map('n', 'gi', lsp.buf.implementation, o)
    map('n', 'ga', lsp.buf.code_action, o)
    map({ 'n', 'x' }, 'gq', lsp.buf.format, o)
    map('n', 'gs', lsp.buf.signature_help, o)
    map('n', 'gw', lsp.buf.rename, o)

    if client:supports_method(lsp.protocol.Methods.textDocument_documentColor) then
      map({ 'n', 'x' }, 'grc', lsp.document_color.color_presentation, o)
    end

    map('n', '<leader>gl', vim.diagnostic.setloclist, o)
    map('n', 'gl', vim.diagnostic.open_float, o)
    map('n', '[g', function() vim.diagnostic.jump({ count = -1, float = true }) end, o)
    map('n', ']g', function() vim.diagnostic.jump({ count = 1, float = true }) end, o)

    if client:supports_method(lsp.protocol.Methods.textDocument_documentHighlight) then
      local hl_group = augroup('lsp-highlight', { clear = false })
      autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr, group = hl_group, callback = lsp.buf.document_highlight,
      })
      autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr, group = hl_group, callback = lsp.buf.clear_references,
      })
      autocmd('LspDetach', {
        group = augroup('lsp-detach', { clear = true }),
        callback = function(ev)
          lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = ev.buf }
        end,
      })
    end

    if client:supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
      lsp.inlay_hint.enable(true)
      map('n', '<leader>th', function()
        lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = bufnr })
      end, o)
    end

    if client:supports_method(lsp.protocol.Methods.textDocument_foldingRange) then
      vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    end

    if client:supports_method(lsp.protocol.Methods.textDocument_completion) then
      local chars = {}
      for i = 32, 126 do chars[#chars + 1] = string.char(i) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
      lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })

      map('i', '<cr>', function()
        return vim.fn.pumvisible() ~= 0 and '<C-y>' or '<cr>'
      end, { expr = true, buffer = bufnr })

      map('i', '<C-n>', function()
        if vim.fn.pumvisible() ~= 0 then
          feedkeys('<C-n>')
        elseif next(lsp.get_clients { bufnr = 0 }) then
          lsp.completion.get()
        elseif vim.bo.omnifunc ~= '' then
          feedkeys('<C-x><C-o>')
        else
          feedkeys('<C-x><C-n>')
        end
      end, { buffer = bufnr })

      map('i', '<C-u>', '<C-x><C-n>', { buffer = bufnr })
    end

    if client.name == 'clangd' then
      map('n', '<leader>ch', '<cmd>LspClangdSwitchSourceHeader<cr>', o)
      map('n', '<leader>cs', '<cmd>LspClangdShowSymbolInfo<cr>', o)
    end
  end,
})

map({ 'i', 's' }, '<Tab>', function()
  local ok, copilot = pcall(require, 'copilot.suggestion')
  if ok and copilot.is_visible() then
    copilot.accept()
  elseif vim.fn.pumvisible() ~= 0 then
    feedkeys('<C-n>')
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    feedkeys('<Tab>')
  end
end)

map({ 'i', 's' }, '<S-Tab>', function()
  if vim.fn.pumvisible() ~= 0 then
    feedkeys('<C-p>')
  elseif vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  else
    feedkeys('<S-Tab>')
  end
end)

map('s', '<BS>', '<C-o>s')
