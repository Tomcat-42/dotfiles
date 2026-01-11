local filetype = vim.filetype

filetype.add({
  extension = {
    p = "p",
    ebnf = "ebnf",
    fmf = "yaml",
    v = "verilog",
    vh = "verilog",
    scm = "scheme",
    smd = 'supermd',
    shtml = 'superhtml',
    ziggy = 'ziggy',
    ['ziggy-schema'] = 'ziggy_schema',
  },
  filename = {
    ["Makefile.inc"] = "make",
  },
})
