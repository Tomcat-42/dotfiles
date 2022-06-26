local present, fluttertools = pcall(require, "flutter-tools")

if not present then
   return
end

local options = {}

fluttertools.setup(options)
