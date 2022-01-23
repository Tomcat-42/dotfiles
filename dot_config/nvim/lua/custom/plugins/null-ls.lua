local ok, null_ls = pcall(require, "null-ls")

if not ok then
   return
end

local b = null_ls.builtins

local sources = {
  b.code_actions.gitsigns,
  b.hover.dictionary,
  -- asm
  b.formatting.asmfmt,
  -- python
  b.formatting.black,
  b.formatting.yapf,
  b.formatting.autopep8,
  b.diagnostics.flake8,
  b.diagnostics.pylint,
  b.formatting.isort,
  -- c
  b.formatting.clang_format,
  b.formatting.uncrustify,
  b.diagnostics.cppcheck,
  -- cmake
  b.formatting.cmake_format,
  -- dart
  b.formatting.dart_format,
  -- deno
  b.formatting.deno_fmt,
  -- eslint_d
  b.formatting.eslint_d,
  b.diagnostics.eslint_d,
  -- prettierd
  b.formatting.prettierd,
  -- json
  b.formatting.fixjson,
  -- go
  b.formatting.gofumpt,
  -- lua
  b.formatting.lua_format,
  b.formatting.stylua,
  b.formatting.luacheck,
  b.diagnostics.luacheck.with {extra_args = { "--global vim" }},
  b.diagnostics.selene,
  -- md
  b.formatting.markdownlint,
  b.diagnostics.markdownlint,
  b.diagnostics.write_good,
  -- b.diagnostics.proselint,
  -- nginx
  b.formatting.nginx_beautifier,
  -- ruby
  b.formatting.rubocop,
  b.diagnostics.rubocop,
  b.formatting.rufo,
  -- rust
  b.formatting.rustfmt,
  -- tailwindcss
  b.formatting.rustywind,
  -- shell
  b.diagnostics.shellcheck,
  b.formatting.shfmt,
  b.formatting.shellharden,

  -- outros
  b.formatting.trim_newlines,
  b.formatting.trim_whitespace,
  b.formatting.codespell,
  -- css
  b.formatting.stylelint,
  b.diagnostics.stylelint,
  -- docker
  b.diagnostics.hadolint,
  --vim
  b.diagnostics.vint,
}

local M = {}
M.setup = function(on_attach)
   null_ls.config {
      sources = sources,
   }
   require("lspconfig")["null-ls"].setup { on_attach = on_attach }
end

return M
