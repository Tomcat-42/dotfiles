local present, goto_preview = pcall(require, "goto-preview")

if not present then return end

local options = { default_mappings = true }

goto_preview.setup(options)
