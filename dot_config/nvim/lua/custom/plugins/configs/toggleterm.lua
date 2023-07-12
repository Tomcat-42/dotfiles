local present, tooggleterm = pcall(require, "toggleterm")

if not present then
  return
end

local options = {}

tooggleterm.setup(options)
