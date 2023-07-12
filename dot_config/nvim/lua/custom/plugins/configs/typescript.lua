local present, typescript = pcall(require, "typescript")

if not present then
  return
end

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local options = {
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false, -- enable debug logging for commands
  go_to_source_definition = {
    fallback = true, -- fall back to standard LSP definition on failure
  },
  server = { -- pass options to lspconfig's setup method
    on_attach = on_attach,
    capabilities = capabilities,
  },
}
