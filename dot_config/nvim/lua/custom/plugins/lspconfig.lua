local M = {}

M.setup_lsp = function(attach, capabilities)
   local lspconfig = require "lspconfig"
   local pid = vim.fn.getpid()

   -- Enable (broadcasting) snippet capability for completion
   local capabilities = vim.lsp.protocol.make_client_capabilities()
   capabilities.textDocument.completion.completionItem.snippetSupport = true

   local servers = {
      "angularls",
      "bashls",
      "clangd",
      "clojure_lsp",
      "cmake",
      -- "csharp_ls",
      "omnisharp",
      "dockerls",
      "gopls",
      "graphql",
      "gdscript",
      "hls",
      "intelephense",
      "prismals",
      "pyright",
      "rust_analyzer",
      "solargraph",
      "stylelint_lsp",
      "svelte",
      "tailwindcss",
      "texlab",
      "vimls",
      "vuels",
      "yamlls",
   }

   for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
         on_attach = attach,
         capabilities = capabilities,
         -- root_dir = vim.loop.cwd,
         flags = { debounce_text_changes = 150 },
      }
   end

   lspconfig.sqlls.setup {
      on_attach = attach,
      capabilities = capabilities,
      cmd = { "sql-language-server", "up", "--method", "stdio" },
   }

   lspconfig.omnisharp.setup {
      on_attach = attach,
      capabilities = capabilities,
      cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(pid) },
   }

   lspconfig.elixirls.setup {
      on_attach = attach,
      capabilities = capabilities,
      cmd = { "elixir-ls" },
   }

   lspconfig.html.setup { on_attach = attach, capabilities = capabilities }

   lspconfig.cssls.setup { on_attach = attach, capabilities = capabilities }

   lspconfig.arduino_language_server.setup {
      on_attach = attach,
      capabilities = capabilities,
      cmd = {
         "arduino-language-server",
         "-cli-config",
         "~/.arduino15/arduino-cli.yaml",
      },
   }
   -- typescript
   lspconfig.tsserver.setup {
      on_attach = attach,
      capabilities = capabilities,
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = {
         "javascript",
         "javascriptreact",
         "javascript.jsx",
         "typescript",
         "typescriptreact",
         "typescript.tsx",
      },
      root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
   }

   lspconfig.jsonls.setup {
      on_attach = attach,
      capabilities = capabilities,
      commands = {
         Format = {
            function()
               vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
            end,
         },
      },
   }

   local sumneko_root_path = "lua-language-server"
   local sumneko_binary = "lua-language-server"

   local runtime_path = vim.split(package.path, ";")
   table.insert(runtime_path, "lua/?.lua")
   table.insert(runtime_path, "lua/?/init.lua")
   lspconfig.sumneko_lua.setup {
      cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
      on_attach = attach,
      capabilities = capabilities,
      settings = {
         Lua = {
            runtime = {
               -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
               version = "LuaJIT",
               -- Setup your lua path
               path = runtime_path,
            },
            diagnostics = {
               -- Get the language server to recognize the `vim` global
               globals = { "vim" },
            },
            workspace = {
               -- Make the server aware of Neovim runtime files
               library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
         },
      },
   }
end

return M
