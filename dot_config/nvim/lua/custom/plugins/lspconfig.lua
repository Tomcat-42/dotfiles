local M = {}

M.setup_lsp = function(attach, capabilities)
    local lspconfig = require "lspconfig"

    local servers = {
        "html", "cssls", "bashls", "asm_lsp", "awk_ls", "cmake",
        "cssmodules_ls", "dockerls", "emmet_ls", "eslint", "ghdl_ls",
        "golangci_lint_ls", "gopls", "hdl_checker", "hls", "marksman",
        "pyright", "sqlls", "texlab", "vimls", "yamlls"
    }

    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {on_attach = attach, capabilities = capabilities}
    end

    -- lua
    lspconfig.sumneko_lua.setup {
        on_attach = attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT'
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {enable = false}
            }
        }
    }

    -- arduino
    lspconfig.arduino_language_server.setup {
        on_attach = attach,
        capabilities = capabilities,
        cmd = {
            "arduino-language-server", "-cli-config",
            "/home/pablo/.arduino15/arduino-cli.yaml", "-fqbn",
            "arduino:avr:uno", "-cli", "arduino-cli", "-clangd", "clangd"
        }
    }

    -- Typescript
    local function organize_imports()
        local params = {
            command = "_typescript.organizeImports",
            arguments = {vim.api.nvim_buf_get_name(0)},
            title = ""
        }
        vim.lsp.buf.execute_command(params)
    end

    lspconfig.tsserver.setup {
        on_attach = attach,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150},
        commands = {
            OrganizeImports = {
                organize_imports,
                description = "Organize Imports"
            }
        }
    }

    lspconfig.jsonls.setup {
        on_attach = attach,
        capabilities = capabilities,
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = {enable = true}
            }
        }
    }

    lspconfig.ltex.setup({
        on_attach = attach,
        capabilities = capabilities,
        settings = {
            ltex = {
                enabled = {"latex", "tex", "bib", "markdown"},
                language = "en",
                diagnosticSeverity = "information",
                setenceCacheSize = 2000,
                additionalRules = {enablePickyRules = true, motherTongue = "en"},
                trace = {server = "verbose"},
                dictionary = {},
                disabledRules = {},
                hiddenFalsePositives = {}
            }
        }
    })
end

return M
