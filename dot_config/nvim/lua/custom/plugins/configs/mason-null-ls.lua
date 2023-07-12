local present, mason_null_ls = pcall(require, "mason-null-ls")

if not present then
  return
end

local options = { automatic_installation = true, automatic_setup = true }

mason_null_ls.setup(options)
