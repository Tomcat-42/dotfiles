local user_command = vim.api.nvim_create_user_command
local map = vim.api.nvim_set_keymap

vim.cmd([[
  command! -range=% FormatCmd <line1>,<line2>s/&&/\\\r\&\&/ge|s/--/\\\r --/ge|s/ -\(\w\)/ \\\r -\1/ge
]])

user_command("DeleteComments", function()
  local comment_pattern = vim.fn.substitute(vim.o.commentstring, "%s", "", "g")
  local escaped_pattern = vim.fn.escape(comment_pattern, "/.*[]~")
  vim.cmd(("g/%s/d"):format(escaped_pattern))
end, {
  range = true,
  desc = "Delete comments in the selected range or whole buffer",
})


local blame_ns = vim.api.nvim_create_namespace("GitBlameVirtText")

user_command("GitBlame", function(args)
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  local cmd = {
    'sh',
    '-c',
    [[
        -- We run blame, format it with awk, but we REMOVE "| uniq"
        -- This ensures we get one output line for every input line.
        git blame -p -L "$1" "$2" | \
        awk '
            /^([0-9a-f]{40})/ { commit=$1 }
            /^(author) / { author=substr($0, 8) }
            /^(author-time) / { time=$2 }
            /^(summary) / { summary=substr($0, 9) }
            /^\t/ {
                date_str = strftime("%Y %b %d", time);
                printf "[%s] %s %s | %s\n", substr(commit,1,8), author, date_str, summary;
            }
        '
    ]],
    'sh',
    args.line1 .. "," .. args.line2,
    filename,
  }

  vim.api.nvim_buf_clear_namespace(bufnr, blame_ns, args.line1 - 1, args.line2)
  vim.system(cmd, { text = true }, vim.schedule_wrap(function(result)
    if result.code ~= 0 then return end

    local blame_lines = vim.split(result.stdout, '\n', { trimempty = true })

    if #blame_lines == 0 then return end

    local start_row = args.line1 - 1
    local previous_blame_text = ""

    for i, blame_text in ipairs(blame_lines) do
      local current_row = start_row + (i - 1)
      local display_text = ""

      if blame_text == previous_blame_text then
        display_text = " --"
      else
        display_text = " " .. blame_text
      end

      vim.api.nvim_buf_set_extmark(bufnr, blame_ns, current_row, -1,
        {
          virt_text = { { display_text, "Comment" } },
          virt_text_pos = 'eol_right_align',
        }
      )

      previous_blame_text = blame_text
    end
  end))
end, {
  range = true,
  desc = "Show git blame virtual text for every line in the selected range",
})

user_command("GitBlameClear", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, blame_ns, 0, -1)
  print("Git blame virtual text cleared.")
end, {
  desc = "Clear git blame virtual text from the buffer",
})

user_command("HexDump", function()
  vim.bo.binary = true
  vim.cmd("%!xxd")
  vim.bo.filetype = "xxd"
  print("Converted to Hex Dump")
end, {
  desc = "Convert current buffer to hex using xxd",
})

user_command("HexRestore", function()
  vim.cmd("%!xxd -r")
  vim.bo.filetype = "binary"
  print("Restored to Binary")
end, {
  desc = "Convert hex dump back to binary",
})

user_command("HexToggle", function()
  local is_hex = vim.fn.getline(1):match("^%x%x%x%x%x%x%x%x:")

  if is_hex then
    vim.cmd("HexRestore")
  else
    vim.cmd("HexDump")
  end
end, {
  desc = "Toggle between binary and hex dump view",
})

-- Run everything in a term
user_command("Run", function(opts)
  local current = vim.fn.expand("%:p")
  local alt = vim.fn.expand("#:p")
  local cmd = opts.args:gsub("%%:p", current):gsub("%%", current):gsub("#", alt)
  vim.cmd("botright new")
  vim.cmd("resize " .. math.floor(vim.o.lines / 4))
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
  vim.b.no_auto_close = true
  vim.fn.termopen(cmd, {
    on_stdout = function()
      vim.schedule(function()
        vim.cmd("normal! G")
      end)
    end,
  }
  )
  map("n", "q", ":q<CR>", { noremap = true, silent = true })
end, {
  desc = "Run the current file in a terminal based on its file type",
  nargs = 1,
  complete = "shellcmd",
})

user_command("Todo", function(args)
  local file, lines = vim.api.nvim_buf_get_name(0), {}
  local scoped = args.range > 0 and file ~= ""
  local scope = scoped and (args.range == 2 and "selection" or "file") or "project"
  local cmd = { "rg", "--vimgrep", "-e", [[\b(TODO|FIXME|HACK|XXX|BUG|WARN)\b]] }
  if scoped then vim.list_extend(cmd, { "--", file }) end

  vim.fn.jobstart(cmd, {
    stdin = "null",
    stdout_buffered = true,
    on_stdout = function(_, data) lines = data end,
    on_exit = function()
      vim.schedule(function()
        local items = {}
        for _, line in ipairs(lines) do
          local f, l, c, t = line:match("^(.+):(%d+):(%d+):(.*)$")
          if f then
            local lnum = tonumber(l)
            if scope ~= "selection" or (lnum >= args.line1 and lnum <= args.line2) then
              items[#items + 1] = { filename = f, lnum = lnum, col = tonumber(c), text = t }
            end
          end
        end
        if #items == 0 then return print("No TODOs found") end
        vim.fn.setqflist({}, "r", { title = "TODOs (" .. scope .. ")", items = items })
        vim.cmd.copen()
      end)
    end,
  })
end, {
  range = true,
  desc = ":Todo (project) | :%Todo (file) | :'<,'>Todo (selection)",
})
