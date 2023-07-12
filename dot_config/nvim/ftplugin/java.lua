local present, jdtls = pcall(require, "jdtls")

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

if not present then
  return
end

local config = {
  cmd = { "jdtls" },
  root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),

  on_attach = on_attach,
  capabilities = capabilities,
}
jdtls.start_or_attach(config)
