local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local grammar_guard = require "grammar-guard"

local servers = {
  "awk_ls",
  "asm_lsp",
  "html",
  "cssls",
  -- "clangd",
  "tailwindcss",
  "bashls",
  "arduino_language_server",
  "cmake",
  -- "dartls",
  "denols",
  "dockerls",
  "golangci_lint_ls",
  "gopls",
  "hls",
  -- "java_language_server",
  -- "jsonls",
  "ltex",
  -- "luau_lsp",
  "marksman",
  "neocmake",
  "prosemd_lsp",
  "pyright",
  -- "remark_ls",
  -- "rust_analyzer",
  "sqlls",
  "stylelint_lsp",
  "texlab",
   "tsserver",
  "vimls",
  "yamlls",
  "zls",
  "prolog_ls"
}

grammar_guard.init()

lspconfig.grammar_guard.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "ltex-ls" },

  settings = {
    ltex = {
      enabled = { "latex", "tex", "bib", "markdown" },
      language = "en",
      diagnosticSeverity = "information",
      setenceCacheSize = 2000,
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "en",
      },
      trace = { server = "verbose" },
      dictionary = {},
      disabledRules = {},
      hiddenFalsePositives = {},
    },
  },
}

lspconfig.jsonls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas {
        select = {
          ".eslintrc",
          "package.json",
        },
      },
      validate = { enable = true },
    },
  },
}

-- lspconfig.lua_ls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = "LuaJIT",
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { "vim" },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = vim.api.nvim_get_runtime_file("", true),
--       },
--       -- Do not send telemetry data containing a randomized but unique identifier
--       telemetry = {
--         enable = false,
--       },
--     },
--   },
-- }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
