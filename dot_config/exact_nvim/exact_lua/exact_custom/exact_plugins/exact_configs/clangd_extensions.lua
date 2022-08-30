local present, clang_extensions = pcall(require, "clangd_extensions")

if not present then return end

local options = {}

clang_extensions.setup(options)
