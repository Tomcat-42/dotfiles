local map = vim.keymap.set
local dap, dapview, dapvirtual = require("dap"), require("dap-view"), require("nvim-dap-virtual-text")

dapview.setup({ windows = { height = 10, } })
dapvirtual.setup({ commented = true, virt_text_pos = "eol" })

-- highlight(0, "DapStopped", vim.api.nvim_get_hl(0, { name = "Visual" }))
-- sign("DapBreakpoint", { text = "⭘", texthl = "DapBreakpoint", linehl = "", numhl = "" })
-- sign("DapBreakpointCondition", { text = "◉", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
-- sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
-- sign("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

map("n", "<leader>dz", function() require("dap-view").toggle(true) end, { desc = "Toggle Dap View" })
map({ "n", "v" }, "<leader>dw", function() require("dap-view").add_expr() end, { desc = "Dapview watch" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Dap continue" })
map("n", "<leader>dh", function() require("dap").step_into() end, { desc = "Dap step into" })
map("n", "<leader>dj", function() require("dap").step_over() end, { desc = "Dap step over" })
map("n", "<leader>dk", function() require("dap").step_out() end, { desc = "Dap step out" })
map("n", "<leader>dl", function() require("dap").step_back() end, { desc = "Dap step back" })
map("n", "<leader>dr", function() require("dap").restart() end, { desc = "Dap restart" })
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Dap toggle breakpoint" })
map("n", "<leader>dp", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end,
  { desc = "Dap set breakpoint" })
map("n", "<leader>di", function() require("dap.ui.widgets").hover(nil, { border = "single" }) end, { desc = "Dap hover" })
map("n", "<leader>ds",
  function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes, { border = "rounded" })
  end, { desc = "Dap scopes" })

local get_args = function()
  local co = assert(coroutine.running(), "Must be called from coroutine")

  vim.schedule(function()
    vim.ui.input({
        prompt = "Args: ",
        completion = "shellcmd",
        default = "",
      },
      function(input)
        coroutine.resume(co, input ~= "" and vim.split(input, "%s+", { plain = false }) or nil)
      end)
  end)

  return coroutine.yield()
end

local get_path = function(default_path)
  return function()
    local co = assert(coroutine.running(), "Must be called from a coroutine")
    local path = vim.fn.getcwd()
    local dir = vim.fn.fnamemodify(path, ":t")
    local default_value = string.format("%s/%s/%s", path, default_path, dir)

    vim.schedule(function()
      vim.ui.input({
          prompt = "Executable: ",
          default = default_value,
          completion = "file",
        },
        function(input)
          vim.notify("PATH == " .. input)
          coroutine.resume(co, input)
        end)
    end)

    return coroutine.yield()
  end
end

local get_pid = function()
  local co = assert(coroutine.running(), "Must be called from a coroutine")
  local default_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  vim.schedule(function()
    vim.ui.input({
        prompt = "Executable name (filter): ",
        completion = "shellcmd",
        default = default_name,
      },
      function(input)
        local pid = require("dap.utils").pick_process({ filter = input })
        coroutine.resume(co, pid)
      end)
  end)

  return coroutine.yield()
end

local get_addr = function(default_addr)
  return function()
    local co = assert(coroutine.running(), "Must be called from a coroutine")

    vim.schedule(function()
      vim.ui.input({
          prompt = "Connect to: ",
          default = default_addr,
        },
        function(input)
          coroutine.resume(co, input)
        end)
    end)

    return coroutine.yield()
  end
end

local get_codelldb_init = function()
  local co = assert(coroutine.running(), "Must be called from a coroutine")

  vim.schedule(function()
    vim.ui.select({
        "remote-linux",
        "remote-android",
        "remote-freebsd",
        "remote-gdb-server",
        "darwin",
        "remote-ios",
        "remote-macosx",
        "host",
        "remote-netbsd",
        "remote-openbsd",
        "qemu-user",
        "remote-windows",
      },
      {
        prompt = "Platform: ",
      },
      function(selected)
        coroutine.resume(co, selected)
      end
    )
  end)
  local platform = coroutine.yield()

  vim.schedule(function()
    vim.ui.input({
        prompt = "Connect to: ",
        default = "localhost:1234",
      },
      function(input)
        coroutine.resume(co, input)
      end)
  end)
  local addr = coroutine.yield()

  return {
    "platform select " .. platform,
    "platform connect connect://" .. addr,
    "settings set target.inherit-env false",
  }
end

dap.adapters = {
  codelldb = {
    name = "codelldb",
    type = "executable",
    command = "codelldb",
  },
  lldb = {
    name = "lldb",
    type = "executable",
    command = "lldb-dap",
    options = {
      initialize_timeout_sec = 10,
    }
  },
  gdb = {
    name = "gdb",
    type = "executable",
    command = "gdb",
    args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
  },
  cppdbg = {
    name = "cppdbg",
    id = "cppdbg",
    type = "executable",
    command = "/usr/share/cpptools-debug/bin/OpenDebugAD7"
  },
  bashdb = {
    type = "executable",
    command = "vscode-bash-debug",
    name = "bashdb",
  },
  ["probe-rs-debug"] = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.expand "$HOME/.cargo/bin/probe-rs",
      args = { "dap-server", "--port", "${port}" },
    },
  },
}

dap.configurations = {
  zig = {
    {
      name = "[codelldb] [launch]",
      type = "codelldb",
      request = "launch",
      program = get_path("zig-out/bin"),
      args = get_args,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "[codelldb] [attach]",
      type = "codelldb",
      request = "attach",
      program = get_path("zig-out/bin"),
      pid = get_pid,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "[codelldb] [connect]",
      type = "codelldb",
      request = "launch",
      initCommands = get_codelldb_init,
      program = get_path("zig-out/bin"),
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "[lldb] [launch]",
      type = "lldb",
      request = "launch",
      program = get_path("zig-out/bin"),
      args = get_args,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
    {
      name = "[gdb] [launch]",
      type = "gdb",
      request = "launch",
      program = get_path("zig-out/bin"),
      args = get_args,
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
    {
      name = "[gdb] [attach]",
      type = "gdb",
      request = "attach",
      program = get_path("zig-out/bin"),
      pid = get_pid,
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
    {
      name = "[gdb] [connect]",
      type = "gdb",
      request = "attach",
      program = get_path("zig-out/bin"),
      target = get_addr("localhost:1234"),
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
    {
      name = "[cppdbg] [launch]",
      type = "cppdbg",
      request = "launch",
      program = get_path("zig-out/bin"),
      args = get_args,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      setupCommands = {
        {
          text = '-enable-pretty-printing',
          description = 'enable pretty printing',
          ignoreFailures = false
        },
      }
    },
    {
      name = "[cppdbg] [attach]",
      type = "cppdbg",
      request = "attach",
      program = get_path("zig-out/bin"),
      processId = get_pid,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
      setupCommands = {
        {
          text = '-enable-pretty-printing',
          description = 'enable pretty printing',
          ignoreFailures = false
        },
      }
    },
    {
      name = "[cppdbg] [connect]",
      type = "cppdbg",
      request = "launch",
      program = get_path("zig-out/bin"),
      miDebuggerServerAddress = get_addr("localhost:1234"),
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      setupCommands = {
        {
          text = '-enable-pretty-printing',
          description = 'enable pretty printing',
          ignoreFailures = false
        },
      }
    },
  },
  sh = {
    {
      name = "[bashdb]",
      type = "bashdb",
      request = "launch",
      showDebuggerOutput = true,
      pathBashdb = "bashdb",
      pathBashdbLib = "/usr/share/bashdb/",
      trace = true,
      file = "${file}",
      program = "${file}",
      cwd = "${workspaceFolder}",
      pathCat = "cat",
      pathBash = "bash",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      args = get_args,
      env = {},
      terminalKind = "integrated",
    }
  },
  asm = {
    {
      name = "[gdb] [connect]",
      type = "gdb",
      request = "attach",
      program = get_path("zig-out/bin"),
      target = get_addr("localhost:1337"),
      cwd = "${workspaceFolder}",
      stopAtBeginningOfMainSubprogram = false,
    },
  },
}
dap.configurations.cpp = dap.configurations.zig
dap.configurations.c = dap.configurations.zig
dap.configurations.rust = dap.configurations.zig

require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust", "zig", "c", "asm" }

dap.listeners.before.attach.dapview_config = dapview.open
dap.listeners.before.launch.dapview_config = dapview.open
dap.listeners.before.event_terminated.dapview_config = dapview.close
dap.listeners.before.event_exited.dapview_config = dapview.close
dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
  local utils = require "dap.utils"
  utils.notify(
    string.format('probe-rs: Opening RTT channel %d with name "%s"!', body.channelNumber, body.channelName)
  )
  local file = io.open("probe-rs.log", "a")
  if file then
    file:write(
      string.format(
        '%s: Opening RTT channel %d with name "%s"!\n',
        os.date "%Y-%m-%d-T%H:%M:%S",
        body.channelNumber,
        body.channelName
      )
    )
  end
  if file then file:close() end
  session:request("rttWindowOpened", { body.channelNumber, true })
end
dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local message =
      string.format("%s: RTT-Channel %d - Message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.channelNumber, body
        .data)
  local repl = require "dap.repl"
  repl.append(message)
  local file = io.open("probe-rs.log", "a")
  if file then file:write(message) end
  if file then file:close() end
end
dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local message = string.format("%s: probe-rs message: %s", os.date "%Y-%m-%d-T%H:%M:%S", body.message)
  local repl = require "dap.repl"
  repl.append(message)
  local file = io.open("probe-rs.log", "a")
  if file then file:write(message) end
  if file then file:close() end
end
