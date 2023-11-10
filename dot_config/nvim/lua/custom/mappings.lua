---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.arduino = {
  plugin = true,
  n = {
    ["<leader>aa"] = { ":ArduinoAttach<CR>", "attach board", opts = { nowait = true } },
    ["<leader>acb"] = { ":ArduinoChooseBoard<CR>", "choose board", opts = { nowait = true } },
    ["<leader>acp"] = { ":ArduinoChooseProgrammer<CR>", "choose programmer", opts = { nowait = true } },
    ["<leader>ap"] = { ":ArduinoChoosePort<CR>", "choose port", opts = { nowait = true } },
    ["<leader>av"] = { ":ArduinoVerify<CR>", "verify code", opts = { nowait = true } },
    ["<leader>au"] = { ":ArduinoUpload<CR>", "upload code", opts = { nowait = true } },
    ["<leader>as"] = { ":ArduinoSerial<CR>", "open serial", opts = { nowait = true } },
    ["<leader>aus"] = { ":ArduinoUploadAndSerial<CR>", "upload and open serial", opts = { nowait = false } },
    ["<leader>ai"] = { ":ArduinoInfo<CR>", "arduino info", opts = { nowait = true } },
    ["<leader>ab"] = { ":ArduinoSetBaud<CR>", "set baud rate", opts = { nowait = true } },
  },
}

M.duckytype = {
  n = { ["<leader>tt"] = { "<cmd>DuckyType<CR>", "DuckyType", opts = { nowait = true } } },
}

M.trouble = {
  n = {
    ["<leader>yy"] = { [[<cmd>lua require("trouble").toggle()<CR>]], "open trouble", opts = { nowait = true } },
    ["<leader>yw"] = {
      [[<cmd>lua require("trouble").open("workspace_diagnostics")<CR>]],
      "workspace diagnostics",
      opts = { nowait = true },
    },
    ["<leader>yd"] = {
      [[<cmd>lua require("trouble").open("document_diagnostics")<CR>]],
      "document diagnostics",
      opts = { nowait = true },
    },
    ["<leader>yq"] = { [[<cmd>lua require("trouble").open("quickfix")<CR>]], "open quickfix", opts = { nowait = true } },
    ["<leader>yl"] = { [[<cmd>lua require("trouble").open("loclist")<CR>]], "open loclist", opts = { nowait = true } },
    ["gR"] = { [[<cmd>lua require("trouble").open("lsp_references")<CR>]], "lsp references", opts = { nowait = true } },
    ["<leader>yn"] = {
      [[<cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>]],
      "jump to next item",
      opts = { nowait = true },
    },
    ["<leader>yp"] = {
      [[<cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>]],
      "jump to previous item",
      opts = { nowait = true },
    },
    ["<leader>yf"] = {
      [[<cmd>lua require("trouble").first({skip_groups = true, jump = true})<CR>]],
      "jump to first item",
      opts = { nowait = true },
    },
    ["<leader>yll"] = {
      [[<cmd>lua require("trouble").last({skip_groups = true, jump = true})<CR>]],
      "jump to last item",
      opts = { nowait = true },
    },
  },
}

M.rust_tools = {
  plugin = true,
  n = {
    -- ["<leader>rca"] = { ":RustCodeAction<CR>", "Rust code action", opts = { nowait = true, silent = true } },
    ["<leader>rd"] = { ":RustDebuggables<CR>", "Rust debuggables", opts = { nowait = true, silent = true } },
    ["<leader>rih"] = {
      ":RustEnableInlayHints<CR>",
      "Enable Rust inlay hints",
      opts = { nowait = true, silent = true },
    },
    ["<leader>rx"] = { ":RustEmitAsm<CR>", "Rust emit assembly", opts = { nowait = true, silent = true } },
    ["<leader>ri"] = { ":RustEmitIr<CR>", "Rust emit IR", opts = { nowait = true, silent = true } },
    ["<leader>re"] = { ":RustExpand<CR>", "Rust expand", opts = { nowait = true, silent = true } },
    ["<leader>rm"] = { ":RustExpandMacro<CR>", "Rust expand macro", opts = { nowait = true, silent = true } },
    ["<leader>rf"] = { ":RustFmt<CR>", "Rust format", opts = { nowait = true, silent = true } },
    ["<leader>rr"] = { ":RustHoverRange<CR>", "Rust hover range", opts = { nowait = true, silent = true } },
    ["<leader>rc"] = { ":RustJoinLines<CR>", "Rust join lines", opts = { nowait = true, silent = true } },
    ["<leader>rl"] = { ":RustLastRun<CR>", "Rust last run", opts = { nowait = true, silent = true } },
    ["<leader>ru"] = { ":RustMoveItemUp<CR>", "Rust move item up", opts = { nowait = true, silent = true } },
    ["<leader>ro"] = { ":RustOpenCargo<CR>", "Rust open Cargo.toml", opts = { nowait = true, silent = true } },
    ["<leader>rp"] = { ":RustPlay<CR>", "Rust play", opts = { nowait = true, silent = true } },
    ["<leader>rw"] = { ":RustReloadWorkspace<CR>", "Rust reload workspace", opts = { nowait = true, silent = true } },
    ["<leader>rrn"] = { ":RustRunnables<CR>", "Rust runnables", opts = { nowait = true, silent = true } },
    ["<leader>rs"] = { ":RustSSR<CR>", "Rust SSR", opts = { nowait = true, silent = true } },
    ["<leader>rv"] = { ":RustViewCrateGraph<CR>", "Rust view crate graph", opts = { nowait = true, silent = true } },
    ["<leader>rg"] = { ":RustLastDebug<CR>", "Rust last debug", opts = { nowait = true, silent = true } },
    ["<leader>ry"] = { ":RustMoveItemDown<CR>", "Rust move item down", opts = { nowait = true, silent = true } },
    ["<leader>rz"] = { ":RustRun<CR>", "Rust run", opts = { nowait = true, silent = true } },
    ["<leader>rj"] = {
      ":RustDisableInlayHints<CR>",
      "Disable Rust inlay hints",
      opts = { nowait = true, silent = true },
    },
    ["<leader>rk"] = { ":RustFmtRange<CR>", "Rust format range", opts = { nowait = true, silent = true } },
    ["<leader>rt"] = { ":RustHoverActions<CR>", "Rust hover actions", opts = { nowait = true, silent = true } },
    ["<leader>rb"] = { ":RustParentModule<CR>", "Rust parent module", opts = { nowait = true, silent = true } },
    ["<leader>ruh"] = { ":RustUnsetInlayHints<CR>", "Rust unset inlay hints", opts = { nowait = true, silent = true } },
    ["<leader>rid"] = {
      ":RustStartStandaloneServerForBuffer<CR>",
      "Rust start standalone server for buffer",
      opts = { nowait = true, silent = true },
    },
    ["<leader>rod"] = {
      ":RustOpenExternalDocs<CR>",
      "Rust open external docs",
      opts = { nowait = true, silent = true },
    },
    ["<leader>sih"] = { ":RustSetInlayHints<CR>", "Rust set inlay hints", opts = { nowait = true, silent = true } },
  },
}

M.clangd = {
  n = {
    ["<leader>ct"] = { "<cmd> ClangdAST <CR>", "ClangdAST" },
    ["<leader>ci"] = { "<cmd> ClangdSymbolInfo <CR>", "ClangdSymbolInfo" },
    ["<leader>ch"] = {
      "<cmd> ClangdTypeHierarchy <CR>",
      "ClangdTypeHierarchy",
    },
    ["<leader>cu"] = {
      "<cmd> ClangdMemoryUsage expand_preamble <CR>",
      "ClangdMemoryUsage expand_preamble",
    },
    ["<leader>cs"] = {
      "<cmd> ClangdSwitchSourceHeader <CR>",
      "ClangdSwitchSourceHeader",
    },
  },
  v = { ["<leader>ct"] = { "<cmd> '<,'>ClangdAST <CR>", "ClangdAST" } },
}

M.zen_mode = { n = { ["<leader>tz"] = { "<cmd> ZenMode <CR>", "ZenMode" } } }

M.twilight = { n = { ["<leader>tw"] = { "<cmd> Twilight <CR>", "twilight" } } }

M.treesitter = {
  n = { ["<leader>cu"] = { "<cmd> TSCaptureUnderCursor <CR>", "find media" } },
}

M.shade = {
  n = {
    ["<leader>s"] = {
      function()
        require("shade").toggle()
      end,
      "toggle shade.nvim",
    },
  },
}

M.nvterm = {
  n = {
    ["<leader>cc"] = {
      function()
        require("nvterm.terminal").send(
          "clear && clang++ -fmodules -fbuiltin-module-map -stdlib=libc++ -std=c++2b -lfmt -o out "
            .. vim.fn.expand "%"
            .. " && ./out",
          "horizontal"
        )
      end,
      "compile & run a cpp file",
    },
  },
}

M.dap = {
  n = {
    ["<leader>du"] = {
      function()
        require("dapui").toggle()
      end,
      "open dapui",
    },
    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "toggle breakpoint" },
    ["<leader>dc"] = { "<cmd> DapContinue <CR>", "dap continue" },
    ["<leader>dsi"] = { "<cmd> DapStepInto <CR>", "dap step into" },
    ["<leader>dso"] = { "<cmd> DapStepOut <CR>", "dap step out" },
    ["<leader>dsv"] = { "<cmd> DapStepOver <CR>", "dap step over" },
    ["<leader>dt"] = { "<cmd> DapTerminate <CR>", "dap terminate" },
    ["<leader>dr"] = { "<cmd> DapToggleRepl <CR>", "dap toggle repl" },
  },
}

M.telescope = {
  n = {
    ["<leader>tbc"] = {
      "<cmd> Telescope dap commands <CR>",
      "Telescope dap commands",
    },
    ["<leader>tbo"] = {
      "<cmd> Telescope dap configurations <CR>",
      "Telescope dap configurations",
    },
    ["<leader>tbb"] = {
      "<cmd> Telescope dap breakpoints <CR>",
      "Telescope dap breakpoints",
    },
    ["<leader>tbv"] = {
      "<cmd> Telescope dap configurations <CR>",
      "Telescope dap variables",
    },
    ["<leader>tbf"] = {
      "<cmd> Telescope dap frames <CR>",
      "Telescope dap frames",
    },
  },
}

M.undotree = {
  n = { ["<leader>u"] = { "<cmd> UndotreeToggle <CR>", "UndotreeToggle" } },
}

M.chatgpt = {
  n = {
    ["<leader>ic"] = { "<cmd> ChatGPT <CR>", "ChatGPT" },
    ["<leader>ia"] = { "<cmd> ChatGPTActAs <CR>", "ChatGPTActAs" },
    ["<leader>ie"] = {
      "<cmd> ChatGPTEditWithInstructions <CR>",
      "ChatGPTEditWithInstructions",
    },
  },
}

M.glsl_view = {
  n = {
    ["<leader>gs"] = { "<cmd> GlslView <CR>", "GlslView" },
  },
}

M.xmake = {
  n = {
    ["<leader>xc"] = { "<cmd> XmakeClean <CR>", "XmakeClean" },
    ["<leader>xb"] = { "<cmd> XmakeBuild <CR>", "XmakeBuild" },
    ["<leader>xr"] = { "<cmd> XmakeRun <CR>", "XmakeRun" },
    ["<leader>xs"] = { "<cmd> XmakeSearch <CR>", "XmakeSearch" },
    ["<leader>xd"] = { "<cmd> XmakeDeps <CR>", "XmakeDeps" },
    ["<leader>xt"] = { "<cmd> XmakeTest <CR>", "XmakeTest" },
    ["<leader>xp"] = { "<cmd> XmakeProject <CR>", "XmakeProject" },
    ["<leader>xu"] = { "<cmd> XmakeUpdate <CR>", "XmakeUpdate" },
    ["<leader>xi"] = { "<cmd> XmakeInstall <CR>", "XmakeInstall" },
    ["<leader>xe"] = { "<cmd> XmakeError <CR>", "XmakeError" },
    ["<leader>xo"] = { "<cmd> XmakeOpen <CR>", "XmakeOpen" },
    ["<leader>xa"] = { "<cmd> XmakeConfig <CR>", "XmakeConfig" },
    ["<leader>xh"] = { "<cmd> XmakeHelp <CR>", "XmakeHelp" },
    ["<leader>xv"] = { "<cmd> XmakeVersion <CR>", "XmakeVersion" },
    ["<leader>xx"] = { "<cmd> XmakeCleanCache <CR>", "XmakeCleanCache" },
  },
}

return M
