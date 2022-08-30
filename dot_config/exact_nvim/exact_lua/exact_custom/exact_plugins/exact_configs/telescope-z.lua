local present, telescope = pcall(require, "telescope")

if not present then return end

telescope.extensions.z.list {cmd = {vim.o.shell, '-c', 'zoxide query -sl'}}
