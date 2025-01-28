local map = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local sign = vim.fn.sign_define

return {
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapViewToggle",
      "DapViewClose",
      "DapViewToggle",
      "DapViewWatch",
    },
    keys = {
      { "<leader>dz", [[<cmd>lua require("dap-view").toggle()<cr>]],       desc = "Toggle Dap View" },
      { "<leader>dw", [[<cmd>lua require("dap-view").add_expr()<cr>]],     desc = "Dapui eval",           mode = { "n", "v" } },
      { "<leader>dc", [[<cmd>lua require("dap").continue()<cr>]],          desc = "Dap continue" },
      { "<leader>dh", [[<cmd>lua require("dap").step_into()<cr>]],         desc = "Dap step into" },
      { "<leader>dj", [[<cmd>lua require("dap").step_over()<cr>]],         desc = "Dap step over" },
      { "<leader>dk", [[<cmd>lua require("dap").step_out()<cr>]],          desc = "Dap step out" },
      { "<leader>dl", [[<cmd>lua require("dap").step_back()<cr>]],         desc = "Dap step back" },
      { "<leader>dr", [[<cmd>lua require("dap").restart()<cr>]],           desc = "Dap restart" },
      { "<leader>db", [[<cmd>lua require("dap").toggle_breakpoint()<cr>]], desc = "Dap toggle breakpoint" },
    },
    dependencies = {
      { "igorlfs/nvim-dap-view",           opts = {} },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    config = function()
      local dap, dapview = require("dap"), require("dap-view")

      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })

      dap.listeners.before.attach.dapview_config = function()
        dapview.open()
      end
      dap.listeners.before.launch.dapview_config = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated.dapview_config = function()
        dapview.close()
      end
      dap.listeners.before.event_exited.dapview_config = function()
        dapview.close()
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = { "/usr/lib/node_modules/local-lua-debugger-vscode/extension/debugAdapter.js" },
        enrich_config = function(config, on_config)
          if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            c.extensionPath = "/usr/lib/node_modules/local-lua-debugger-vscode"
            on_config(c)
          else
            on_config(config)
          end
        end,
      }

      dap.adapters.bashdb = {
        type = 'executable',
        command = 'bashdb',
        name = 'bashdb',
      }

      dap.configurations.sh = {
        {
          type = 'bashdb',
          request = 'launch',
          name = "Launch file",
          showDebugOutput = true,
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = '${workspaceFolder}',
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        }
      }

      dap.configurations.zig = {
        {
          name = 'Main Executable',
          type = 'codelldb',
          request = 'launch',
          program = '${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}',
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          justMyCode = false,
          args = {},
        },
      }

      dap.configurations.lua = {
        {
          name = 'Current file (local-lua-dbg, lua)',
          type = 'local-lua',
          request = 'launch',
          cwd = '${workspaceFolder}',
          program = {
            lua = 'lua',
            file = '${file}',
          },
          args = {},
        },
      }
    end
  },
}
