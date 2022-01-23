local present, spellsitter = pcall(require, "spellsitter")

if not present then
   return
end

spellsitter.setup {
 -- Whether enabled, can be a list of filetypes, e.g. {'python', 'lua'}
  enable = true,

  -- Spellchecker to use. values:
  -- * vimfn: built-in spell checker using vim.fn.spellbadword()
  -- * ffi: built-in spell checker using the FFI to access the
  --   internal spell_check() function
  spellchecker = 'vimfn',
}
