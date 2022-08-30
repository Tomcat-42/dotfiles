local present, command_center = pcall(require, "command-center")

if not present then return end

local noremap = {noremap = true}
local silent_noremap = {noremap = true, silent = true}

command_center.add({
    {
        description = "Search inside current buffer",
        cmd = "<CMD>Telescope current_buffer_fuzzy_find<CR>",
        keybindings = {"n", "<leader>fl", noremap}
    }, {
        -- If no descirption is specified, command is used to replace descirption by default
        -- You can change this behavior in settigns
        cmd = "<CMD>Telescope find_files<CR>",
        keybindings = {"n", "<leader>ff", noremap}
    }, {
        -- If no keybindings specified, no keybindings will be displayed or registered
        description = "Find hidden files",
        cmd = "<CMD>Telescope find_files hidden=true<CR>"
    }, {
        -- You can specify multiple keybindings for the same command ...
        description = "Show document symbols",
        cmd = "<CMD>Telescope lsp_document_symbols<CR>",
        keybindings = {
            {"n", "<leader>ss", noremap}, {"n", "<leader>ssd", noremap}
        }
    }, {
        -- ... and for different modes
        description = "Show function signaure (hover)",
        cmd = "<CMD>lua vim.lsp.buf.hover()<CR>",
        keybindings = {
            {"n", "K", silent_noremap}, {"i", "<C-k>", silent_noremap}
        }
    }, {
        -- You can pass in a key sequence as if they were typed in neovim
        description = "My favorite key sequence",
        cmd = "A  -- Add a comment at the end of a line",
        keybindings = {"n", "<leader>Ac", noremap}
    }, {
        -- You can also pass in a lua functions as command
        -- NOTE: binding lua funciton with key only works with neovim 0.7
        description = "Run lua function",
        cmd = function() print("ANONYMOUS LUA FUNCTION") end,
        keybindings = {"n", "<leader>alf", noremap}
    }, {
        -- If no command is specified, then this entry is ignored
        description = "lsp run linter",
        keybindings = {"n", "<leader>sf", noremap}
    }
})
