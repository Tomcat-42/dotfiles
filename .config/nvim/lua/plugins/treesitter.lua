local autocmd = vim.api.nvim_create_autocmd
local treesitter = vim.treesitter

local langs = {
  "zig", "rust", "c", "cpp", "lua", "bash", "sh", "asm",
  "markdown", "json", "xml", "yaml", "fish", "ebnf", "python",
  "make", "diff", "disassembly", "objdump", "p", "tex", "c3", "dart", "go",
  "cuda",
}

treesitter.language.register("rpmspec", { "spec" })

autocmd("FileType", {
  pattern = langs,
  callback = function(args)
    local buffer = args.buf
    local filetype = vim.bo[buffer].filetype

    local lang = treesitter.language.get_lang(filetype)
    if not lang then
      return
    end

    local ok_add = pcall(treesitter.language.add, lang)
    if not ok_add then
      return
    end

    local ok_start = pcall(treesitter.start, buffer, lang)
    if not ok_start then
      return
    end

    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

autocmd("User", {
  pattern = "TSUpdate",
  callback = function()
    local parsers = require("ntreesitter.parsers")

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

autocmd("FileType", {
  pattern = "spec",
  callback = function(ev)
    treesitter.start(ev.buf, "rpmspec")
    vim.bo.commentstring = "# %s"
    vim.bo.comments = "b:#"
  end,
})

autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "ntreesitter" and kind == "update" then
      if not ev.data.active then vim.cmd.packadd("ntreesitter") end
      vim.cmd("TSUpdate")
    end
  end,
})
