local map = vim.keymap.set
local api = vim.api
local fn = vim.fn
local dap = require("dap")
local dapview = require("dap-view")
local dap_disasm = require("dap-disasm")
local dap_bps = require("dap.breakpoints")

dapview.setup({
  winbar = {
    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console", "disassembly" },
    controls = { enabled = false },
  },
  windows = { size = 0.25 },
  auto_toggle = true,
  virtual_text = { enabled = true },
})

dap_disasm.setup({ dapview_register = true })

local function co_input(opts)
  local co = assert(coroutine.running())
  vim.schedule(function() vim.ui.input(opts, function(c) coroutine.resume(co, c) end) end)
  return coroutine.yield()
end

local function co_select(items, opts)
  local co = assert(coroutine.running())
  vim.schedule(function() vim.ui.select(items, opts, function(c) coroutine.resume(co, c) end) end)
  return coroutine.yield()
end

local function find_executables()
  local cwd = fn.getcwd()
  local dirs = { "zig-out/bin", "target/debug", "target/release", "build", "bin", "." }
  local paths = vim.iter(dirs):map(function(d) return cwd .. "/" .. d end):join(" ")
  return fn.systemlist("find " ..
    paths .. " -maxdepth 2 -type f -executable 2>/dev/null | grep -vE '\\.o$|\\.d$' | head -50")
end

local function get_program()
  local exes = find_executables()
  if #exes == 1 then return exes[1] end
  if #exes > 1 then return co_select(exes, { prompt = "Executable: " }) end
  return co_input({
    prompt = "Executable: ",
    default = fn.getcwd() .. "/" .. fn.fnamemodify(fn.getcwd(), ":t"),
    completion = "file",
  })
end

local last_args = nil
local function get_args()
  local input = co_input({
    prompt = "Args: ",
    default = last_args and table.concat(last_args, " ") or "",
    completion = "shellcmd",
  })
  last_args = input ~= "" and vim.split(input, "%s+", { plain = false }) or nil
  return last_args
end

local function get_pid()
  return require("dap.utils").pick_process({
    filter = co_input({ prompt = "Filter: ", completion = "shellcmd", default = fn.fnamemodify(fn.getcwd(), ":t") }),
  })
end

local function get_addr(default)
  return function() return co_input({ prompt = "Connect to: ", default = default }) end
end

local function get_codelldb_init()
  local platform = co_select({
    "remote-linux", "remote-android", "remote-freebsd", "remote-gdb-server",
    "darwin", "remote-ios", "remote-macosx", "host",
    "remote-netbsd", "remote-openbsd", "qemu-user", "remote-windows",
  }, { prompt = "Platform: " })
  local addr = co_input({ prompt = "Connect to: ", default = "localhost:1234" })
  return { "platform select " .. platform, "platform connect connect://" .. addr, "settings set target.inherit-env false" }
end

local bp_file = fn.stdpath("data") .. "/dap_breakpoints.json"

local function save_bps()
  local bps = {}
  for buf, marks in pairs(dap_bps.get()) do
    local name = api.nvim_buf_get_name(buf)
    if name ~= "" then bps[name] = marks end
  end
  local f = io.open(bp_file, "w")
  if f then
    f:write(vim.json.encode(bps))
    f:close()
  end
end

local function load_bps()
  local f = io.open(bp_file, "r")
  if not f then return end
  local ok, bps = pcall(vim.json.decode, f:read("*a"))
  f:close()
  if not ok or not bps then return end
  for name, marks in pairs(bps) do
    if fn.bufnr(name) ~= -1 then
      for _, bp in ipairs(marks) do
        dap.set_breakpoint(bp.condition, bp.hitCondition, bp.logMessage)
      end
    end
  end
end

api.nvim_create_autocmd("BufReadPost", { once = true, callback = function() pcall(load_bps) end })

dap.adapters = {
  codelldb           = { name = "codelldb", type = "executable", command = "codelldb" },
  lldb               = { name = "lldb", type = "executable", command = "lldb-dap", options = { initialize_timeout_sec = 10 } },
  gdb                = { name = "gdb", type = "executable", command = "gdb", args = { "--interpreter=dap", "--eval-command", "set print pretty on" } },
  bashdb             = { name = "bashdb", type = "executable", command = "vscode-bash-debug" },
  ["probe-rs-debug"] = {
    type = "server",
    port = "${port}",
    executable = { command = fn.expand("$HOME/.cargo/bin/probe-rs"), args = { "dap-server", "--port", "${port}" } },
  },
}

local function make_configs(adapter, modes)
  local result = {}
  local base = { type = adapter, program = get_program, cwd = "${workspaceFolder}" }
  for _, mode in ipairs(modes) do
    local config = vim.tbl_extend("force", base, mode[2])
    config.name = string.format("[%s] [%s]", adapter, mode[1])
    config.request = config.request or (mode[1] == "attach" and "attach" or "launch")
    result[#result + 1] = config
  end
  return result
end

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

for _, ft in ipairs({ "zig", "cpp", "c", "rust", "asm" }) do
  dap.configurations[ft] = native_configs
end

dap.configurations.sh = { {
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
} }

require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust", "zig", "c", "asm" }

map("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
map("n", "<leader>dR", dap.run_last, { desc = "DAP re-run last" })
map("n", "<leader>dh", dap.step_into, { desc = "DAP step into" })
map("n", "<leader>dj", dap.step_over, { desc = "DAP step over" })
map("n", "<leader>dk", dap.step_out, { desc = "DAP step out" })
map("n", "<leader>dl", dap.step_back, { desc = "DAP step back" })
map("n", "<leader>dr", dap.restart, { desc = "DAP restart" })
map("n", "<leader>dx", dap.terminate, { desc = "DAP terminate" })
map("n", "<leader>db", function() dap.toggle_breakpoint(); save_bps() end, { desc = "DAP breakpoint" })
map("n", "<leader>dp", function() dap.set_breakpoint(fn.input("Condition: ")); save_bps() end, { desc = "DAP conditional bp" })
map("n", "<leader>dL", function() dap.set_breakpoint(nil, nil, fn.input("Log: ")); save_bps() end, { desc = "DAP log point" })
map("n", "<leader>dB", function() dap.clear_breakpoints(); save_bps() end, { desc = "DAP clear breakpoints" })
map("n", "<leader>dz", dapview.toggle, { desc = "DAP view" })
map("n", "<leader>dv", dapview.virtual_text_toggle, { desc = "DAP virtual text toggle" })
map({ "n", "v" }, "<leader>dw", dapview.add_expr, { desc = "DAP watch" })
map("n", "<leader>di", function() require("dap.ui.widgets").hover(nil, { border = "single" }) end, { desc = "DAP hover" })

local function log_probe_rs(msg)
  local f = io.open("probe-rs.log", "a")
  if f then
    f:write(msg)
    f:close()
  end
end

dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(session, body)
  local msg = string.format('%s: Opening RTT channel %d with name "%s"!\n',
    os.date("%Y-%m-%d-T%H:%M:%S"), body.channelNumber, body.channelName)
  require("dap.utils").notify(msg)
  log_probe_rs(msg)
  session:request("rttWindowOpened", { body.channelNumber, true })
end

dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local msg = string.format("%s: RTT-Channel %d - Message: %s",
    os.date("%Y-%m-%d-T%H:%M:%S"), body.channelNumber, body.data)
  require("dap.repl").append(msg)
  log_probe_rs(msg)
end

dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
  local msg = string.format("%s: probe-rs message: %s", os.date("%Y-%m-%d-T%H:%M:%S"), body.message)
  require("dap.repl").append(msg)
  log_probe_rs(msg)
end
