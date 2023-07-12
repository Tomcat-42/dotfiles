local M = {}

M.general = {
    n = {[";"] = {":", "command mode", opts = {nowait = true}}},

    i = {["jk"] = {"<ESC>", "escape vim"}}
}

M.zen_mode = {n = {["<leader>tz"] = {"<cmd> ZenMode <CR>", "ZenMode"}}}

M.twilight = {n = {["<leader>tw"] = {"<cmd> Twilight <CR>", "twilight"}}}

M.treesitter = {
    n = {["<leader>cu"] = {"<cmd> TSCaptureUnderCursor <CR>", "find media"}}
}

M.shade = {
    n = {
        ["<leader>s"] = {
            function() require("shade").toggle() end, "toggle shade.nvim"
        }
    }
}

M.nvterm = {
    n = {
        ["<leader>cc"] = {
            function()
                require("nvterm.terminal").send(
                    "clear && clang++ -stdlib=libc++ -std=c++2b -lfmt -o out " .. vim.fn.expand "%" ..
                        " && ./out", "horizontal")
            end, "compile & run a cpp file"
        }
    }
}

M.dap = {
    n = {
        ["<leader>du"] = {
            function() require("dapui").toggle() end, "open dapui"
        },
        ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "toggle breakpoint"},
        ["<leader>dc"] = {"<cmd> DapContinue <CR>", "dap continue"},
        ["<leader>dsi"] = {"<cmd> DapStepInto <CR>", "dap step into"},
        ["<leader>dso"] = {"<cmd> DapStepOut <CR>", "dap step out"},
        ["<leader>dsv"] = {"<cmd> DapStepOver <CR>", "dap step over"},
        ["<leader>dt"] = {"<cmd> DapTerminate <CR>", "dap terminate"},
        ["<leader>dr"] = {"<cmd> DapToggleRepl <CR>", "dap toggle repl"}
    }
}

M.rust_tools = {
    n = {
        ["<leader>rr"] = {"<cmd> RustRunnables <CR>", "Rust Runnables"},
        ["<leader>rd"] = {"<cmd> RustDebuggables <CR>", "Rust Debuggables"},
        ["<leader>rm"] = {"<cmd> RustExpandMacro <CR>", "Rust Expand Macro"},
        ["<leader>rh"] = {"<cmd> RustHoverActions <CR>", "Rust Hover Actions"},
        ["<leader>rc"] = {"<cmd> RustOpenCargo <CR>", "Rust Open Cargo"},
        ["<leader>rs"] = {"<cmd> RustRun <CR>", "Rust Run Single"},
        ["<leader>rp"] = {"<cmd> RustPlay <CR>", "Rust Play Online"},
        ["<leader>rpm"] = {"<cmd> RustParentModule <CR>", "Rust Parent Module"},
        ["<leader>red"] = {"<cmd> RustExternalDocs <CR>", "Rust External Docs"},
        ["<leader>rw"] = {
            "<cmd> RustReloadWorkspace <CR>", "Rust Reload Workspace"
        },
        ["<leader>rg"] = {
            "<cmd> RustViewCrateGraph <CR>", "Rust View Create Graph"
        }
    }
}

M.telescope = {
    n = {
        ["<leader>tbc"] = {
            "<cmd> Telescope dap commands <CR>", "Telescope dap commands"
        },
        ["<leader>tbo"] = {
            "<cmd> Telescope dap configurations <CR>",
            "Telescope dap configurations"
        },
        ["<leader>tbb"] = {
            "<cmd> Telescope dap breakpoints <CR>", "Telescope dap breakpoints"
        },
        ["<leader>tbv"] = {
            "<cmd> Telescope dap configurations <CR>", "Telescope dap variables"
        },
        ["<leader>tbf"] = {
            "<cmd> Telescope dap frames <CR>", "Telescope dap frames"
        }
    }
}

M.clangd = {
    n = {
        ["<leader>ct"] = {"<cmd> ClangdAST <CR>", "ClangdAST"},
        ["<leader>ci"] = {"<cmd> ClangdSymbolInfo <CR>", "ClangdSymbolInfo"},
        ["<leader>ch"] = {
            "<cmd> ClangdTypeHierarchy <CR>", "ClangdTypeHierarchy"
        },
        ["<leader>cu"] = {
            "<cmd> ClangdMemoryUsage expand_preamble <CR>",
            "ClangdMemoryUsage expand_preamble"
        },
        ["<leader>cs"] = {
            "<cmd> ClangdSwitchSourceHeader <CR>", "ClangdSwitchSourceHeader"
        }
    },
    v = {["<leader>ct"] = {"<cmd> '<,'>ClangdAST <CR>", "ClangdAST"}}
}

M.trouble = {
    n = {
        ["<leader>ll"] = {"<cmd> TroubleToggle <CR>", "TroubleToggle"},
        ["<leader>lw"] = {
            "<cmd> TroubleToggle workspace_diagnostics <CR>",
            "TroubleToggle workspace_diagnostics"
        },
        ["<leader>ld"] = {
            "<cmd> TroubleToggle document_diagnostics <CR>",
            "TroubleToggle document_diagnostics"
        },
        ["<leader>lt"] = {
            "<cmd> TroubleToggle loclist <CR>", "TroubleToggle loclist"
        },
        ["<leader>lq"] = {
            "<cmd> TroubleToggle quickfix <CR>", "TroubleToggle quickfix"
        },
        ["<leader>lr"] = {
            "<cmd> TroubleToggle lsp_references <CR>",
            "TroubleToggle lsp_references"
        }
    }
}

M.undotree = {
    n = {["<leader>u"] = {"<cmd> UndotreeToggle <CR>", "UndotreeToggle"}}
}

-- M.copilot = {
--     i = {
--         ["<C-j>"] = {
--             'copilot#Accept("<CR>")',
--             "ﮧ  copilot completion",
--             opts = {silent = true, script = true, expr = true}
--         }
--     }
-- }

M.chatgpt = {
    n = {
        ["<leader>ic"] = {"<cmd> ChatGPT <CR>", "ChatGPT"},
        ["<leader>ia"] = {"<cmd> ChatGPTActAs <CR>", "ChatGPTActAs"},
        ["<leader>ie"] = {
            "<cmd> ChatGPTEditWithInstructions <CR>",
            "ChatGPTEditWithInstructions"
        }
    }
}
M.flutter ={
  n = {
        ["<leader>tf"] = {"<cmd> Telescope flutter commands <CR>", "flutter commands"},

  }
}

return M
