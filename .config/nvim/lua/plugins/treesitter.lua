local langs = {
  "zig",
  "rust",
  "c",
  "cpp",
  "lua",
  "bash",
  "asm",
  "markdown",
  "json",
  "xml",
  "yaml",
  "fish",
  "ebnf",
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
