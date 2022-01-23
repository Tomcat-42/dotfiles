local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
   return
end

treesitter.setup {
  matchup = { enable = true },
  context_commentstring = {
    enable = true
  },
  autotag = {
    enable = true,
  },
   ensure_installed = {
      "lua",
      "vim",
   },
   
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   incremental_selection = {
       enable = true,
       keymaps = {
         init_selection = "gnn",
         node_incremental = "grn",
         scope_incremental = "grc",
         node_decremental = "grm",
       },
   },
    indent = {
      enable = true
    },
      rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = {
                  "#bd93f9",
                  "#50fa7b",
                  "#ff5555",
                  "#f1fa8c",
                  "#6272a4",
                  "#ff79c6",
                  "#8be9fd"
                },
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
    refactor = {
      highlight_definitions = { enable = true },
      highlight_current_scope = { enable = true },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr",
        },
      },
         navigation = {
            enable = true,
            keymaps = {
              goto_definition = "gnd",
              list_definitions = "gnD",
              list_definitions_toc = "gO",
              goto_next_usage = "<a-*>",
              goto_previous_usage = "<a-#>",
            },
          },
    },
}
