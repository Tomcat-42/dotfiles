local filetype = vim.filetype

filetype.add({
  extension = {
    scm = "scheme",
    smd = 'supermd',
    shtml = 'superhtml',
    ziggy = 'ziggy',
    ['ziggy-schema'] = 'ziggy_schema',
  }
})
