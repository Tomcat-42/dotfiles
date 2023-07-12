local present, dap_python = pcall(require, "dap-python")

if not present then
  return
end

local options = "~/.virtualenvs/debugpy/bin/python"

dap_python.test_runner = "pytest"

dap_python.setup(options)
