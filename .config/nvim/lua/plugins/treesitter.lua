local autocmd = vim.api.nvim_create_autocmd

local langs = {
  "zig", "rust", "c", "cpp", "lua", "bash", "sh", "asm",
  "markdown", "json", "xml", "yaml", "fish", "ebnf", "python",
  "make", "diff", "disassembly", "objdump", "p", "tex", "c3", "dart", "go",
  "cuda",
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
    local parsers = require("nvim-treesitter.parsers")

    parsers.p = {
      install_info = {
        path = "~/dev/compilers/p/tools/tree-sitter-p/tools/tree-sitter-p",
        generate = false,
        generate_from_json = false,
        queries = "queries/",
      },
    }

    parsers.rpmspec = {
      install_info = {
        url = "https://github.com/cryptomilk/tree-sitter-rpmspec",
        location = "rpmspec",
        queries = "neovim/queries/rpmspec",
      },
    }

    parsers.rpmbash = {
      install_info = {
        url = "https://github.com/cryptomilk/tree-sitter-rpmspec",
        location = "rpmbash",
        queries = "neovim/queries/rpmbash",
      },
    }
  end,
})

vim.treesitter.language.register("rpmspec", { "spec" })

autocmd("FileType", {
  pattern = "spec",
  callback = function(ev)
    vim.treesitter.start(ev.buf, "rpmspec")
    vim.bo.commentstring = "# %s"
    vim.bo.comments = "b:#"
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
