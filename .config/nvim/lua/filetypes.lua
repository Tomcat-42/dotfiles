local filetype = vim.filetype

filetype.add({
  extension = {
    ebnf = "ebnf",
    fmf = "yaml",
    v = "verilog",
    vh = "verilog",
    scm = "scheme",
    smd = 'supermd',
    shtml = 'superhtml',
    ziggy = 'ziggy',
    ['ziggy-schema'] = 'ziggy_schema',
  }
})
