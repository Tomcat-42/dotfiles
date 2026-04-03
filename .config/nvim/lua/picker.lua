local map = vim.keymap.set
local command = vim.api.nvim_create_user_command
local fn = vim.fn
assert(fn.executable "rg" == 1)

local function fuzzy(items, lead)
  return lead == '' and items or fn.matchfuzzy(items, lead)
end

local function rg(args, limit)
  return fn.systemlist("rg --vimgrep --no-heading --smart-case -- " .. args .. " | head -" .. limit)
end

local function parse_vimgrep(lines)
  local items = {}
  for _, line in ipairs(lines) do
    local file, lnum, col, text = line:match("^(.+):(%d+):(%d+):(.*)$")
    if file then
      items[#items + 1] = { filename = file, lnum = tonumber(lnum), col = tonumber(col), text = vim.trim(text) }
    end
  end
  return items
end

local function to_qf(title, items)
  if #items == 0 then return print("No results found") end
  fn.setqflist({}, 'r', { title = title, items = items })
  vim.cmd.copen()
end

-- Find files
_G._findfunc = function(cmdarg, _)
  local fnames = fn.systemlist("rg --files --hidden --color=never --glob='!.git'")
  return cmdarg == '' and fnames or fn.matchfuzzy(fnames, cmdarg)
end
vim.o.findfunc = 'v:lua._findfunc'

-- Pickers
command("Buffer", function(opts) vim.cmd("buffer " .. opts.args) end, {
  nargs = 1,
  complete = function(lead)
    local names = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[b].buflisted and vim.api.nvim_buf_get_name(b) ~= '' then
        names[#names + 1] = fn.fnamemodify(vim.api.nvim_buf_get_name(b), ':~:.')
      end
    end
    return fuzzy(names, lead)
  end,
})

command("H", function(opts) vim.cmd.help(opts.args) end, {
  nargs = 1,
  complete = function(lead) return fn.getcompletion(lead, 'help') end,
})

command("Recent", function(opts) vim.cmd.edit(opts.args) end, {
  nargs = 1,
  complete = function(lead)
    local files = {}
    for _, f in ipairs(vim.v.oldfiles) do
      if vim.uv.fs_stat(f) then files[#files + 1] = fn.fnamemodify(f, ':~:.') end
    end
    return fuzzy(files, lead)
  end,
})

command("Cmd", function(opts) vim.cmd(opts.args) end, {
  nargs = 1,
  complete = function(lead) return fn.getcompletion(lead, 'command') end,
})

command("Grep", function(opts)
  local items = parse_vimgrep(rg(fn.shellescape(opts.args), 500))
  to_qf('Grep: ' .. opts.args, items)
end, { nargs = '+' })

command("LiveGrep", function(opts)
  local file, lnum = opts.args:match("^(.+):(%d+):")
  if file and lnum then
    vim.cmd.edit(file)
    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
  end
end, {
  nargs = 1,
  complete = function(lead)
    if #lead < 3 then return {} end
    local items = parse_vimgrep(rg(fn.shellescape(lead), 200))
    return vim.tbl_map(function(i) return i.filename .. ':' .. i.lnum .. ': ' .. i.text end, items)
  end,
})

-- LSP symbols
command("Symbols", function()
  vim.lsp.buf_request(0, 'textDocument/documentSymbol',
    { textDocument = vim.lsp.util.make_text_document_params() },
    function(err, result)
      if err or not result or #result == 0 then
        return vim.notify('No symbols found', vim.log.levels.INFO)
      end
      local items, bufnr = {}, vim.api.nvim_get_current_buf()
      local function flatten(symbols, prefix)
        for _, s in ipairs(symbols) do
          local name = prefix ~= '' and (prefix .. '.' .. s.name) or s.name
          local range = s.selectionRange or s.range
          items[#items + 1] = {
            bufnr = bufnr, lnum = range.start.line + 1, col = range.start.character + 1,
            text = (vim.lsp.protocol.SymbolKind[s.kind] or '?') .. ': ' .. name,
          }
          if s.children then flatten(s.children, name) end
        end
      end
      flatten(result, '')
      vim.schedule(function() to_qf('Document Symbols', items) end)
    end)
end, {})

command("WSymbols", function(opts)
  local query = opts.args ~= '' and opts.args or fn.input('Symbol query: ')
  if query == '' then return end
  vim.lsp.buf_request(0, 'workspace/symbol', { query = query }, function(err, result)
    if err or not result or #result == 0 then
      return vim.notify('No symbols found', vim.log.levels.INFO)
    end
    local items = {}
    for _, s in ipairs(result) do
      local loc = s.location
      items[#items + 1] = {
        filename = vim.uri_to_fname(loc.uri), lnum = loc.range.start.line + 1,
        col = loc.range.start.character + 1,
        text = (vim.lsp.protocol.SymbolKind[s.kind] or '?') .. ': ' .. s.name,
      }
    end
    vim.schedule(function() to_qf('Workspace Symbols: ' .. query, items) end)
  end)
end, { nargs = '?' })

command("Bin", function(opts)
  vim.cmd("Run " .. opts.args)
end, {
  nargs = 1,
  complete = function(lead)
    local exes = fn.systemlist("find . -type f -executable -not -path '*/.git/*' 2>/dev/null | head -100")
    return fuzzy(exes, lead)
  end,
})

-- Cmdline helpers
local find_cmds = { find = true, fin = true, sfind = true, tabfind = true }
map('c', '<m-e>', '<home><s-right><c-w>edit<end>')
map('c', '<m-d>', function()
  local cmd = fn.getcmdline():match("^(%S+)")
  if not cmd or not find_cmds[cmd] then return end
  local arg = fn.getcmdline():match("^%S+%s+(.+)")
  if not arg or not vim.uv.fs_realpath(fn.expand(arg)) then
    return vim.notify('Invalid path', vim.log.levels.ERROR)
  end
  fn.feedkeys(vim.api.nvim_replace_termcodes('<C-U>edit ' .. vim.fs.dirname(arg), true, true, true), 'c')
end)
map('c', '<c-v>', '<home><s-right><c-w>vs<end>')
map('c', '<c-s>', '<home><s-right><c-w>sp<end>')
map('c', '<c-t>', '<home><s-right><c-w>tabe<end>')

-- Keymaps
map('n', '<leader>ff', ':find ', { desc = 'Find file' })
map('n', '<leader>fb', ':Buffer ', { desc = 'Buffers' })
map('n', '<leader>fh', ':H ', { desc = 'Help' })
map('n', '<leader>fo', ':Recent ', { desc = 'Recent files' })
map('n', '<leader>fc', ':Cmd ', { desc = 'Commands' })
map('n', '<leader>fw', ':Grep ', { desc = 'Grep (quickfix)' })
map('n', '<leader>fl', ':LiveGrep ', { desc = 'Live grep' })
map('n', '<leader>fs', '<cmd>Symbols<cr>', { silent = true, desc = 'Document symbols' })
map('n', '<leader>fS', ':WSymbols ', { desc = 'Workspace symbols' })
map('n', '<leader>fm', ':Man ', { desc = 'Man page' })
map('n', '<leader>fr', ':Bin ', { desc = 'Run executable' })
