local present, rusttools = pcall(require, "rust-tools")

if not present then
   return
end

local options = {}

rusttools.setup(options)
