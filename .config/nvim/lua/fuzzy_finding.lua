local map = vim.keymap.set

assert(vim.fn.executable "rg" == 1)

function _G.RgFindFiles(cmdarg, _)
  local fnames = vim.fn.systemlist(
    "rg --files --hidden --color=never --glob='!.git'"
  )

  if #cmdarg == 0 then
    return fnames
  end

  return vim.fn.matchfuzzy(fnames, cmdarg)
end

vim.o.findfunc = 'v:lua.RgFindFiles'

local function is_cmdline_type_find()
  local cmdline_cmd = vim.fn.split(vim.fn.getcmdline(), ' ')[1]
  return cmdline_cmd == 'find' or cmdline_cmd == 'fin'
end

map('c', '<m-e>', '<home><s-right><c-w>edit<end>', { desc = 'Change command to :edit' })
map('c', '<m-d>', function()
  if not is_cmdline_type_find() then return end

  local cmdline_arg = vim.fn.split(vim.fn.getcmdline(), ' ')[2]

  if vim.uv.fs_realpath(vim.fn.expand(cmdline_arg)) == nil then
    vim.notify('The second argument should be a valid path', vim.log.levels.ERROR)
    return
  end

  local keys = vim.api.nvim_replace_termcodes(
    '<C-U>edit ' .. vim.fs.dirname(cmdline_arg),
    true,
    true,
    true
  )
  vim.fn.feedkeys(keys, 'c')
end, { desc = 'Edit the dir for the path' })
map('c', '<c-v>', '<home><s-right><c-w>vs<end>', { desc = 'Change command to :vs' })
map('c', '<c-s>', '<home><s-right><c-w>sp<end>', { desc = 'Change command to :sp' })
map('c', '<c-t>', '<home><s-right><c-w>tabe<end>', { desc = 'Change command to :tabe' })
