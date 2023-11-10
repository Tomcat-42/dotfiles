local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- change filetype of files: *.vert, *.frag, *.geom to glsl
autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.{vert,frag,geom,tess,tesc,comp}",
  command = "set filetype=glsl",
})
