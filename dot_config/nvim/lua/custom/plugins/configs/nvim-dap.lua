local present, nvim_dap = pcall(require, "nvim-dap")

if not present then return end

local options = {}

nvim_dap.setup(options)
