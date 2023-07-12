local present, flutter_tools = pcall(require, "flutter-tools")

if not present then return end

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local configs = {
    ui = {
        -- the border type to use for all floating windows, the same options/formats
        -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
        border = "rounded",
        -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
        -- please note that this option is eventually going to be deprecated and users will need to
        -- depend on plugins like `nvim-notify` instead.
        notification_style = 'plugin'
    },
    decorations = {
        statusline = {
            -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
            -- this will show the current version of the flutter app from the pubspec.yaml file
            app_version = true,
            -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
            -- this will show the currently running device if an application was started with a specific
            -- device
            device = true
        }
    },
    debugger = { -- integrate with nvim dap + install dart code debugger
        enabled = true,
        run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
        -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
        -- see |:help dap.set_exception_breakpoints()| for more info
        exception_breakpoints = {},
        register_configurations = function(_)
            require("dap").configurations.dart = {}
        end
    },
    flutter_path = "/opt/flutter/bin/flutter", -- <-- this takes priority over the lookup
    flutter_lookup_cmd = nil, -- example "dirname $(which flutter)" or "asdf where flutter"
    fvm = false, -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
    widget_guides = {enabled = true},
    closing_tags = {
        highlight = "ErrorMsg", -- highlight for the closing tag
        prefix = ">", -- character to use for close tag e.g. > Widget
        enabled = true -- set to false to disable
    },
    dev_log = {
        enabled = true,
        open_cmd = "tabedit" -- command to use to open the log buffer
    },
    dev_tools = {
        autostart = false, -- autostart devtools server if not detected
        auto_open_browser = false -- Automatically opens devtools in the browser
    },
    outline = {
        open_cmd = "60vnew", -- command to use to open the outline buffer
        auto_open = true -- if true this will open the outline automatically when it is first populated
    },
    lsp = {
        color = { -- show the derived colours for dart variables
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = false, -- highlight the background
            background_color = {r = 0, g = 0, b = 0}, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = true, -- highlight the foreground
            virtual_text = false, -- show the highlight using virtual text
            virtual_text_str = "■" -- the virtual text character to highlight
        },
        on_attach = on_attach,
        capabilities = capabilities, -- e.g. lsp_status capabilities
        -- see the link below for details on each option:
        -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
        settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {"/opt/flutter/packages/"},
            renameFilesWithClasses = "prompt", -- "always"
            enableSnippets = true
        }
    }
}

flutter_tools.setup(configs)
