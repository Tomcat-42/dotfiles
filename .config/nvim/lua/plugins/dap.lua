local map = vim.keymap.set
local api = vim.api
local fn = vim.fn
local dap = require("dap")
local dapview = require("dap-view")

dapview.setup({
  winbar = {
    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console", "disassembly" },
    controls = { enabled = false },
  },
  windows = { size = 0.25 },
  auto_toggle = true,
  virtual_text = { enabled = true },
})

require("dap-disasm").setup({ dapview_register = true })

for name, sign in pairs({
  DapBreakpoint          = { texthl = "Special" },
  DapBreakpointCondition = { texthl = "DiagnosticWarn" },
  DapLogPoint            = { texthl = "DiagnosticInfo" },
  DapBreakpointRejected  = { texthl = "Comment" },
  DapStopped             = { texthl = "DiagnosticOk", linehl = "CursorLine" },
}) do fn.sign_define(name, sign) end

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

local last_program = nil

local function get_program()
  local cwd = fn.getcwd()
  local dirs = { "zig-out/bin", "target/debug", "target/release", "build", "bin", "." }
  local paths = vim.iter(dirs):map(function(d) return cwd .. "/" .. d end):join(" ")
  local exes = fn.systemlist("find " ..
    paths .. " -maxdepth 2 -type f -executable 2>/dev/null | grep -vE '\\.o$|\\.d$' | head -50")
  if #exes == 1 then last_program = exes[1]
  elseif #exes > 1 then last_program = co_select(exes, { prompt = "Executable: " })
  else last_program = co_input({
    prompt = "Executable: ",
    default = cwd .. "/" .. fn.fnamemodify(cwd, ":t"),
    completion = "file",
  }) end
  return last_program
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

local function save_bps()
  local bps = {}
  for buf, marks in pairs(require("dap.breakpoints").get()) do
    local name = api.nvim_buf_get_name(buf)
    if name ~= "" then bps[name] = marks end
  end
  local f = io.open(fn.stdpath("data") .. "/dap_breakpoints.json", "w")
  if f then f:write(vim.json.encode(bps)); f:close() end
end

api.nvim_create_autocmd("BufReadPost", {
  once = true,
  callback = function()
    local f = io.open(fn.stdpath("data") .. "/dap_breakpoints.json", "r")
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
  end,
})

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

local native_configs = {}

for adapter, modes in pairs({
  codelldb = {
    { "launch",  { args = get_args, stopOnEntry = false } },
    { "attach",  { pid = function()
      return require("dap.utils").pick_process({
        filter = co_input({ prompt = "Filter: ", completion = "shellcmd", default = fn.fnamemodify(fn.getcwd(), ":t") }),
      })
    end, stopOnEntry = false } },
    { "connect", { initCommands = function()
      local platform = co_select({
        "remote-linux", "remote-android", "remote-freebsd", "remote-gdb-server",
        "darwin", "remote-ios", "remote-macosx", "host",
        "remote-netbsd", "remote-openbsd", "qemu-user", "remote-windows",
      }, { prompt = "Platform: " })
      local addr = co_input({ prompt = "Connect to: ", default = "localhost:1234" })
      return { "platform select " .. platform, "platform connect connect://" .. addr, "settings set target.inherit-env false" }
    end, stopOnEntry = false } },
  },
  lldb = {
    { "launch", { args = get_args, stopOnEntry = false } },
  },
  gdb = {
    { "launch",  { args = get_args, stopAtBeginningOfMainSubprogram = false } },
    { "attach",  { pid = function()
      return require("dap.utils").pick_process({
        filter = co_input({ prompt = "Filter: ", completion = "shellcmd", default = fn.fnamemodify(fn.getcwd(), ":t") }),
      })
    end, stopAtBeginningOfMainSubprogram = false } },
    { "connect", { request = "attach", target = function()
      return co_input({ prompt = "Connect to: ", default = "localhost:1234" })
    end, stopAtBeginningOfMainSubprogram = false } },
  },
}) do
  for _, mode in ipairs(modes) do
    local config = vim.tbl_extend("force", { type = adapter, program = get_program, cwd = "${workspaceFolder}" }, mode[2])
    config.name = string.format("[%s] [%s]", adapter, mode[1])
    config.request = config.request or (mode[1] == "attach" and "attach" or "launch")
    native_configs[#native_configs + 1] = config
  end
end

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

local last_config = nil
dap.listeners.after.event_initialized["cache_config"] = function(session)
  last_config = vim.deepcopy(session.config)
end

map("n", "<leader>dc", dap.continue, { desc = "DAP continue" })
map("n", "<leader>dR", function()
  if last_config then dap.run(last_config) else dap.run_last() end
end, { desc = "DAP re-run last" })
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
  if f then f:write(msg); f:close() end
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
