local present, null_ls = pcall(require, "null-ls")

if not present then
   return
end

local b = null_ls.builtins

local sources = {

  -- code_actions
  b.code_actions.eslint_d,
  b.code_actions.gitrebase,
  b.code_actions.gitsigns,
  b.code_actions.proselint,
  b.code_actions.shellcheck,

  -- completion
  b.completion.luasnip,
  b.completion.tags,

  -- diagnostics
  b.diagnostics.checkmake,
  b.diagnostics.cppcheck,
  b.diagnostics.eslint_d,
  b.diagnostics.flake8,
  b.diagnostics.gitlint,
  b.diagnostics.golangci_lint,
  b.diagnostics.hadolint,
  b.diagnostics.jsonlint,
  b.diagnostics.luacheck,
  b.diagnostics.markdownlint,
  b.diagnostics.mypy,
  b.diagnostics.pydocstyle,
  b.diagnostics.pylama,
  b.diagnostics.pylint,
  b.diagnostics.proselint,
  b.diagnostics.protoc_gen_lint,
  b.diagnostics.protolint,
  b.diagnostics.revive,
  b.diagnostics.selene,
  b.diagnostics.shellcheck,
  b.diagnostics.sqlfluff,
  b.diagnostics.staticcheck,
  b.diagnostics.stylelint,
  b.diagnostics.trail_space,
  b.diagnostics.vint,
  b.diagnostics.vulture,
  b.diagnostics.yamllint,
  b.diagnostics.zsh,

  -- formatting
  b.formatting.asmfmt,
  b.formatting.astyle,
  b.formatting.autopep8,
  b.formatting.bibclean,
  b.formatting.black,
  b.formatting.brittany,
  b.formatting.buf,
  b.formatting.clang_format,
  b.formatting.cmake_format,
  b.formatting.dart_format,
  b.formatting.eslint_d,
  b.formatting.fixjson,
  b.formatting.gofumpt,
  b.formatting.goimports,
  b.formatting.golines,
  b.formatting.google_java_format,
  b.formatting.isort,
  b.formatting.jq,
  b.formatting.json_tool,
  b.formatting.latexindent,
  b.formatting.lua_format,
  b.formatting.prettier_d_slim,
  b.formatting.pg_format,
  b.formatting.protolint,
  b.formatting.rustfmt,
  b.formatting.shellharden,
  b.formatting.shfmt,
  b.formatting.sqlfluff,
  b.formatting.sqlformat,
  b.formatting.sql_formatter,
  b.formatting.tidy,
  b.formatting.trim_newlines,
  b.formatting.trim_whitespace,
  b.formatting.uncrustify,
  b.formatting.yapf,

  -- hover
  b.hover.dictionary,
}

null_ls.setup {
   debug = true,
   sources = sources,
}
