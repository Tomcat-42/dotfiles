local autocmd = vim.api.nvim_create_autocmd

local vcs_cache = {}

local function update_vcs_info()
  local bufnr = vim.api.nvim_get_current_buf()

  local jj_root = vim.fs.root(0, ".jj")
  if jj_root then
    vim.system(
      { "jj", "log", "--no-graph", "-r", "@", "-T", 'if(bookmarks, bookmarks.join(", "), change_id.shortest(8))' },
      { cwd = jj_root, text = true },
      function(result)
        vcs_cache[bufnr] = result.code == 0 and vim.trim(result.stdout) or ""
        vim.schedule(vim.cmd.redrawstatus)
      end
    )
    return
  end

  local git_root = vim.fs.root(0, ".git")
  if git_root then
    vim.uv.fs_open(git_root .. "/.git/HEAD", "r", 438, function(err, fd)
      if err or not fd then
        vcs_cache[bufnr] = ""
        return
      end
      vim.uv.fs_read(fd, 256, 0, function(err2, data)
        vim.uv.fs_close(fd)
        if err2 or not data then
          vcs_cache[bufnr] = ""
          return
        end
        local line = data:match("^[^\n]+")
        vcs_cache[bufnr] = line and (line:match("ref: refs/heads/(.+)") or line:sub(1, 8)) or ""
        vim.schedule(vim.cmd.redrawstatus)
      end)
    end)
    return
  end

  vcs_cache[bufnr] = ""
end

autocmd({ "BufEnter", "DirChanged", "FocusGained" }, { callback = update_vcs_info })

function _G.statusline_extra()
  local parts = {}
  local vcs = vcs_cache[vim.api.nvim_get_current_buf()] or ""
  if vcs ~= "" then parts[#parts + 1] = vcs end
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients > 0 then
    local names = vim.iter(clients)
      :map(function(c) return (c.name:gsub("language.server", "ls")) end)
      :totable()
    parts[#parts + 1] = "[" .. table.concat(names, ", ") .. "]"
  end
  return #parts > 0 and table.concat(parts, " ") .. " " or ""
end

vim.o.statusline = table.concat({
  "%<%f %h%w%m%r",
  "%=",
  "%{%v:lua._G.statusline_extra()%}",
  "%{% &busy > 0 ? '\u{25d0} ' : '' %}",
  "%{% v:lua.vim.diagnostic.status() != '' ? v:lua.vim.diagnostic.status() .. ' ' : '' %}",
  "%-14.(%l,%c%V%) %P",
})
