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

vim.diagnostic.config({
  float = { border = "single" },
  virtual_text = {
    virt_text_pos = "eol_right_align",
    prefix = '->',
  },
  signs = true,
  underline = true,
})

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', true)
end

local function pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

autocmd("LspAttach", {
  group = augroup("UserLspAttach", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))
    local methods = lsp.protocol.Methods
    local o = { buffer = event.buf }

    map('n', 'ge', lsp.buf.references, o)
    map('n', 'gd', lsp.buf.definition, o)
    map('n', 'gD', lsp.buf.declaration, o)
    map('n', 'go', lsp.buf.type_definition, o)
    map('n', 'gi', lsp.buf.implementation, o)
    map('n', 'ga', lsp.buf.code_action, o)
    map({ 'n', 'x' }, 'gq', lsp.buf.format, o)
    map('n', 'K', lsp.buf.hover, o)
    map('n', 'gs', lsp.buf.signature_help, o)
    map('i', '<C-s>', lsp.buf.signature_help, o)
    map('n', 'gw', lsp.buf.rename, o)

    if client:supports_method(lsp.protocol.Methods.textDocument_documentColor) then
      map({ 'n', 'x' }, 'grc', lsp.document_color.color_presentation, o)
    end
    map('n', '<leader>gl', vim.diagnostic.setloclist, o)
    map('n', 'gl', vim.diagnostic.open_float, o)
    map('n', '[g', function() vim.diagnostic.jump({ count = -1 }) end, o)
    map('n', ']g', function() vim.diagnostic.jump({ count = 1 }) end, o)

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

    if client:supports_method(lsp.protocol.Methods.textDocument_inlayHint) then
      lsp.inlay_hint.enable(true)
      map('n', '<leader>v', function() lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled()) end, o)
      map("n", "<leader>th", function()
        lsp.inlay_hint.enable(not lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, o)
    end

    if client:supports_method(methods.textDocument_completion) then
      lsp.completion.enable(true, client.id, bufnr)

      map('i', '<cr>', function() return pumvisible() and '<C-y>' or '<cr>' end, { expr = true, buffer = bufnr })

      map('i', '<C-n>', function()
        if pumvisible() then
          feedkeys '<C-n>'
        elseif next(lsp.get_clients { bufnr = 0 }) then
          lsp.completion.get()
        elseif vim.bo.omnifunc ~= '' then
          feedkeys '<C-x><C-o>'
        else
          feedkeys '<C-x><C-n>'
        end
      end, { desc = 'Trigger/select next completion', buffer = bufnr })

      map('i', '<C-u>', '<C-x><C-n>', { desc = 'Buffer completions', buffer = bufnr })
    end
  end,
})

map({ 'i', 's' }, '<Tab>', function()
  local ok, copilot = pcall(require, 'copilot.suggestion')
  if ok and copilot.is_visible() then
    copilot.accept()
  elseif pumvisible() then
    feedkeys '<C-n>'
  elseif vim.snippet.active { direction = 1 } then
    vim.snippet.jump(1)
  else
    feedkeys '<Tab>'
  end
end)

map({ 'i', 's' }, '<S-Tab>', function()
  if pumvisible() then
    feedkeys '<C-p>'
  elseif vim.snippet.active { direction = -1 } then
    vim.snippet.jump(-1)
  else
    feedkeys '<S-Tab>'
  end
end)

map('s', '<BS>', '<C-o>s')

autocmd({ "BufEnter", "BufWinEnter" }, {
  group = augroup("UserClangd", { clear = true }),
  pattern = { "*.cpp", "*.hpp", "*.c", "*.h" },
  callback = function()
    map({ 'n', 'x' }, '<leader>ch', function()
      vim.cmd('LspClangdSwitchSourceHeader')
    end)
    map({ 'n', 'x' }, '<leader>cs', function()
      vim.cmd('LspClangdShowSymbolInfo')
    end)
  end
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
