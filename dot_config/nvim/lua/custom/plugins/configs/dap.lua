local present, dap = pcall(require, "dap")

if not present then return end

vim.fn.sign_define("DapBreakpoint",
                   {text = "", texthl = "", linehl = "", numhl = ""})

local client_notifs = {}

local function get_notif_data(client_id, token)
    if not client_notifs[client_id] then client_notifs[client_id] = {} end

    if not client_notifs[client_id][token] then
        client_notifs[client_id][token] = {}
    end

    return client_notifs[client_id][token]
end

local spinner_frames = {"⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"}

local function update_spinner(client_id, token)
    local notif_data = get_notif_data(client_id, token)

    if notif_data.spinner then
        local new_spinner = (notif_data.spinner + 1) % #spinner_frames
        notif_data.spinner = new_spinner

        notif_data.notification = vim.notify(nil, nil, {
            hide_from_history = true,
            icon = spinner_frames[new_spinner],
            replace = notif_data.notification
        })

        vim.defer_fn(function() update_spinner(client_id, token) end, 100)
    end
end

local function format_title(title, client_name)
    return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
    return (percentage and percentage .. "%\t" or "") .. (message or "")
end

-- DAP integration
-- Make sure to also have the snippet with the common helper functions in your config!

dap.listeners.before["event_progressStart"]["progress-notifications"] =
    function(session, body)
        local notif_data = get_notif_data("dap", body.progressId)

        local message = format_message(body.message, body.percentage)
        notif_data.notification = vim.notify(message, "info", {
            title = format_title(body.title, session.config.type),
            icon = spinner_frames[1],
            timeout = false,
            hide_from_history = false
        })

        notif_data.notification.spinner = 1, update_spinner("dap",
                                                            body.progressId)
    end

dap.listeners.before["event_progressUpdate"]["progress-notifications"] =
    function(session, body)
        local notif_data = get_notif_data("dap", body.progressId)
        notif_data.notification = vim.notify(
                                      format_message(body.message,
                                                     body.percentage), "info", {
                replace = notif_data.notification,
                hide_from_history = false
            })
    end

dap.listeners.before["event_progressEnd"]["progress-notifications"] = function(
    session, body)
    local notif_data = client_notifs["dap"][body.progressId]
    notif_data.notification = vim.notify(body.message and
                                             format_message(body.message) or
                                             "Complete", "info", {
        icon = "",
        replace = notif_data.notification,
        timeout = 3000
    })
    notif_data.spinner = nil
end

-- Bash
dap.adapters.bashdb = {
    type = "executable",
    command = vim.fn.stdpath "data" ..
        "/mason/packages/bash-debug-adapter/bash-debug-adapter",
    name = "bashdb"
}

dap.configurations.sh = {
    {
        type = "bashdb",
        request = "launch",
        name = "Launch file",
        showDebugOutput = true,
        pathBashdb = vim.fn.stdpath "data" ..
            "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
        pathBashdbLib = vim.fn.stdpath "data" ..
            "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
        trace = true,
        file = "${file}",
        program = "${file}",
        cwd = "${workspaceFolder}",
        pathCat = "cat",
        pathBash = "/bin/bash",
        pathMkfifo = "mkfifo",
        pathPkill = "pkill",
        args = {},
        env = {},
        terminalKind = "integrated"
    }
}

-- C-like
dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
    name = "lldb"
}

dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "/home/pablo/.vscode/extensions/ms-vscode.cpptools-1.13.9-linux-x64/debugAdapters/bin/OpenDebugAD7",
    env = function()
        local variables = {}
        for k, v in pairs(vim.fn.environ()) do
            table.insert(variables, string.format("%s=%s", k, v))
        end
        return variables
    end
}

-- Dart
dap.adapters.dart = {
    type = "executable",
    command = "node",
    args = {
        "/home/pablo/.vscode/extensions/dart-code.dart-code-3.56.0/out/dist/debug.js",
        "flutter"
    }
}

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        -- CHANGE THIS to your path!
        command = "/home/pablo/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/adapter/codelldb",
        args = {"--port", "${port}"}
    },
    env = function()
        local variables = {}
        for k, v in pairs(vim.fn.environ()) do
            table.insert(variables, string.format("%s=%s", k, v))
        end
        return variables
    end
}
dap.configurations.dart = {
    {
        type = "dart",
        request = "launch",
        name = "Launch flutter",
        dartSdkPath = os.getenv('HOME') .. "/flutter/bin/cache/dart-sdk/",
        flutterSdkPath = os.getenv('HOME') .. "/flutter",
        program = "${workspaceFolder}/lib/main.dart",
        cwd = "${workspaceFolder}"
    }
}

dap.configurations.cpp = {
    {
        name = "Launch LLDB",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/",
                                "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
    }, {
        name = "Launch CPPDBG ",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/",
                                "file")
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false
            }
        },
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end
    }, {
        name = "Attach to gdbserver :1234 CPP DBG",
        type = "cppdbg",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/",
                                "file")
        end,
        setupCommands = {
            {
                text = "-enable-pretty-printing",
                description = "enable pretty printing",
                ignoreFailures = false
            }
        },
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end
    }, {
        name = "Launch CODELLDB",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/",
                                "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        env = function()
            local variables = {}
            for k, v in pairs(vim.fn.environ()) do
                table.insert(variables, string.format("%s=%s", k, v))
            end
            return variables
        end
    }
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- golang
dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {command = "dlv", args = {"dap", "-l", "127.0.0.1:${port}"}}
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {type = "delve", name = "Debug", request = "launch", program = "${file}"},
    {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}"
    }, -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }
}

-- haskell
dap.adapters.haskell = {
    type = "executable",
    command = "haskell-debug-adapter",
    args = {"--hackage-version=0.0.33.0"}
}
dap.configurations.haskell = {
    {
        type = "haskell",
        request = "launch",
        name = "Debug",
        workspace = "${workspaceFolder}",
        startup = "${file}",
        stopOnEntry = true,
        logFile = vim.fn.stdpath "data" .. "/haskell-dap.log",
        logLevel = "WARNING",
        ghciEnv = vim.empty_dict(),
        ghciPrompt = "λ: ",
        -- Adjust the prompt to the prompt you see when you invoke the stack ghci command below
        ghciInitialPrompt = "λ: ",
        ghciCmd = "stack ghci --test --no-load --no-build --main-is TARGET --ghci-options -fprint-evld-with-show"
    }
}

-- js
