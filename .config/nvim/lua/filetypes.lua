local filetype = vim.filetype

filetype.add({
  extension = {
    p = "p",
    ebnf = "ebnf",
    fmf = "yaml",
    v = "verilog",
    vh = "verilog",
    scm = "scheme",
  },
  filename = {
    ["Makefile.inc"] = "make",
  },
})
