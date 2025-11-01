local user_command = vim.api.nvim_create_user_command

vim.cmd([[
  command! -range=% FormatCmd <line1>,<line2>s/&&/\\\r\&\&/ge|s/--/\\\r --/ge|s/ -\(\w\)/ \\\r -\1/ge
]])

user_command("DeleteComments", function()
	local comment_pattern = vim.fn.substitute(vim.o.commentstring, "%s", "", "g")
	local escaped_pattern = vim.fn.escape(comment_pattern, "/.*[]~")
	vim.cmd(("g/%s/d"):format(escaped_pattern))
end, {
	range = true,
	desc = "Delete comments in the selected range or whole buffer",
})
