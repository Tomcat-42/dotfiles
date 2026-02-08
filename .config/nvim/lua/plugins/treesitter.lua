local langs = {
  "zig",
  "rust",
  "c",
  "cpp",
  "lua",
  "bash",
  "sh",
  "asm",
  "markdown",
  "json",
  "xml",
  "yaml",
  "fish",
  "ebnf",
  "python",
  "make",
  "diff",
  "disassembly",
  "objdump",
  "p",
  "tex",
  "c3",
  "dart",
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
    vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt_local.foldmethod = 'expr'
    vim.bo.indentexpr = "nvim_treesitter#indent()"
  end,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').p = {
      install_info = {
        -- url = 'https://github.com/Tomcat-42/p',
        path = '~/dev/compilers/p/tools/tree-sitter-p/tools/tree-sitter-p',
        -- location = 'tools/tree-sitter-p',
        generate = false,
        generate_from_json = false,
        queries = 'queries/',
      },
    }
  end
})
