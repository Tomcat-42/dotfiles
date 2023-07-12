local present, plugin = pcall(require, "plugin")

if not present then
  return
end

local options = {}

plugin.setup(options)
