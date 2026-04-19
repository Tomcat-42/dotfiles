local autocmd = vim.api.nvim_create_autocmd

local langs = {
  "zig", "rust", "c", "cpp", "lua", "bash", "sh", "asm",
  "markdown", "json", "xml", "yaml", "fish", "ebnf", "python",
  "make", "diff", "disassembly", "objdump", "p", "tex", "c3", "dart", "go",
}

autocmd("FileType", {
  pattern = langs,
  callback = function()
    vim.treesitter.start()
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldmethod = "expr"
    vim.bo.indentexpr = "nvim_treesitter#indent()"
  end,
})

autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    require("nvim-treesitter.parsers").p = {
      install_info = {
        path = "~/dev/compilers/p/tools/tree-sitter-p/tools/tree-sitter-p",
        generate = false,
        generate_from_json = false,
        queries = "queries/",
      },
    }
  end,
})

autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then vim.cmd.packadd("nvim-treesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})
