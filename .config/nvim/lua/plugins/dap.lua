local map = vim.keymap.set
local dap, dapview, dapvirtual = require("dap"), require("dap-view"), require("nvim-dap-virtual-text")

dapview.setup({ windows = { size = 10 } })
dapvirtual.setup({ commented = true, virt_text_pos = "eol" })

-- Keymaps
map("n", "<leader>dz", function() dapview.toggle(true) end, { desc = "DAP view" })
map({ "n", "v" }, "<leader>dw", dapview.add_expr, { desc = "DAP watch" })
map("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
map("n", "<leader>dh", dap.step_into, { desc = "DAP step into" })
map("n", "<leader>dj", dap.step_over, { desc = "DAP step over" })
map("n", "<leader>dk", dap.step_out, { desc = "DAP step out" })
map("n", "<leader>dl", dap.step_back, { desc = "DAP step back" })
map("n", "<leader>dr", dap.restart, { desc = "DAP restart" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
map("n", "<leader>dp", function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end,
  { desc = "DAP conditional breakpoint" })
map("n", "<leader>di", function() require("dap.ui.widgets").hover(nil, { border = "single" }) end,
  { desc = "DAP hover" })
map("n", "<leader>ds", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes, { border = "rounded" })
end, { desc = "DAP scopes" })

-- Input helpers (coroutine-based for DAP)
local function get_args()
  local co = assert(coroutine.running(), "Must be called from coroutine")
  vim.schedule(function()
    vim.ui.input({ prompt = "Args: ", completion = "shellcmd" }, function(input)
      coroutine.resume(co, input ~= "" and vim.split(input, "%s+", { plain = false }) or nil)
    end)
  end)
  return coroutine.yield()
end

local function get_path(default_path)
  return function()
    local co = assert(coroutine.running(), "Must be called from a coroutine")
    local cwd = vim.fn.getcwd()
    local default = string.format("%s/%s/%s", cwd, default_path, vim.fn.fnamemodify(cwd, ":t"))
    vim.schedule(function()
      vim.ui.input({ prompt = "Executable: ", default = default, completion = "file" }, function(input)
        coroutine.resume(co, input)
      end)
    end)
    return coroutine.yield()
  end
end

local function get_pid()
  local co = assert(coroutine.running(), "Must be called from a coroutine")
  vim.schedule(function()
    vim.ui.input({
      prompt = "Executable name (filter): ",
      completion = "shellcmd",
      default = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
    }, function(input)
      coroutine.resume(co, require("dap.utils").pick_process({ filter = input }))
    end)
  end)
  return coroutine.yield()
end

local function get_addr(default_addr)
  return function()
    local co = assert(coroutine.running(), "Must be called from a coroutine")
    vim.schedule(function()
      vim.ui.input({ prompt = "Connect to: ", default = default_addr }, function(input)
        coroutine.resume(co, input)
      end)
    end)
    return coroutine.yield()
  end
end

local function get_codelldb_init()
  local co = assert(coroutine.running(), "Must be called from a coroutine")
  vim.schedule(function()
    vim.ui.select({
      "remote-linux", "remote-android", "remote-freebsd", "remote-gdb-server",
      "darwin", "remote-ios", "remote-macosx", "host",
      "remote-netbsd", "remote-openbsd", "qemu-user", "remote-windows",
    }, { prompt = "Platform: " }, function(selected)
      coroutine.resume(co, selected)
    end)
  end)
  local platform = coroutine.yield()

  vim.schedule(function()
    vim.ui.input({ prompt = "Connect to: ", default = "localhost:1234" }, function(input)
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

-- Adapters
dap.adapters = {
  codelldb = { name = "codelldb", type = "executable", command = "codelldb" },
  lldb = {
    name = "lldb",
    type = "executable",
    command = "lldb-dap",
    options = { initialize_timeout_sec = 10 },
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
    command = "/usr/share/cpptools-debug/bin/OpenDebugAD7",
  },
  bashdb = { type = "executable", command = "vscode-bash-debug", name = "bashdb" },
  ["probe-rs-debug"] = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.expand("$HOME/.cargo/bin/probe-rs"),
      args = { "dap-server", "--port", "${port}" },
    },
  },
}

-- Configuration generator: creates [adapter] [mode] entries with shared defaults
local function make_configs(adapter, modes)
  local result = {}
  local base = { type = adapter, program = get_path("zig-out/bin"), cwd = "${workspaceFolder}" }
  for _, mode in ipairs(modes) do
    local name, extra = mode[1], mode[2]
    local config = vim.tbl_extend("force", base, extra)
    config.name = string.format("[%s] [%s]", adapter, name)
    config.request = config.request or (name == "attach" and "attach" or "launch")
    result[#result + 1] = config
  end
  return result
end

local cppdbg_setup = {
  { text = '-enable-pretty-printing', description = 'enable pretty printing', ignoreFailures = false },
}

local native_configs = {}
vim.list_extend(native_configs, make_configs("codelldb", {
  { "launch",  { args = get_args, stopOnEntry = false } },
  { "attach",  { pid = get_pid, stopOnEntry = false } },
  { "connect", { initCommands = get_codelldb_init, stopOnEntry = false } },
}))
vim.list_extend(native_configs, make_configs("lldb", {
  { "launch", { args = get_args, stopOnEntry = false } },
}))
vim.list_extend(native_configs, make_configs("gdb", {
  { "launch",  { args = get_args, stopAtBeginningOfMainSubprogram = false } },
  { "attach",  { pid = get_pid, stopAtBeginningOfMainSubprogram = false } },
  { "connect", { request = "attach", target = get_addr("localhost:1234"), stopAtBeginningOfMainSubprogram = false } },
}))
vim.list_extend(native_configs, make_configs("cppdbg", {
  { "launch",  { args = get_args, stopAtEntry = false, setupCommands = cppdbg_setup } },
  { "attach",  { processId = get_pid, stopAtEntry = false, setupCommands = cppdbg_setup } },
  { "connect", { miDebuggerServerAddress = get_addr("localhost:1234"), stopOnEntry = false, setupCommands = cppdbg_setup } },
}))

dap.configurations.zig = native_configs
dap.configurations.cpp = native_configs
dap.configurations.c = native_configs
dap.configurations.rust = native_configs
dap.configurations.asm = native_configs

dap.configurations.sh = {
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
  },
}

require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust", "zig", "c", "asm" }

-- DAP view listeners
dap.listeners.before.attach.dapview_config = dapview.open
dap.listeners.before.launch.dapview_config = dapview.open
dap.listeners.before.event_terminated.dapview_config = dapview.close
dap.listeners.before.event_exited.dapview_config = dapview.close

-- probe-rs RTT logging
local function log_probe_rs(message)
  local file = io.open("probe-rs.log", "a")
  if file then
    file:write(message)
    file:close()
  end
end

dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
  local msg = string.format(
    '%s: Opening RTT channel %d with name "%s"!\n',
    os.date("%Y-%m-%d-T%H:%M:%S"), body.channelNumber, body.channelName
  )
  require("dap.utils").notify(msg)
  log_probe_rs(msg)
  session:request("rttWindowOpened", { body.channelNumber, true })
end

dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local msg = string.format(
    "%s: RTT-Channel %d - Message: %s",
    os.date("%Y-%m-%d-T%H:%M:%S"), body.channelNumber, body.data
  )
  require("dap.repl").append(msg)
  log_probe_rs(msg)
end

dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local msg = string.format("%s: probe-rs message: %s", os.date("%Y-%m-%d-T%H:%M:%S"), body.message)
  require("dap.repl").append(msg)
  log_probe_rs(msg)
end
