local ui2 = require("vim._core.ui2")
local autocmd = vim.api.nvim_create_autocmd

ui2.enable {
  msg = {
    target = 'msg',
    timeout = 3000,
    targets = {
      emsg = 'cmd',
      wmsg = 'cmd',
      lua_error = 'cmd',
      echoerr = 'cmd',
      search_count = 'cmd',
    },
  },
}

autocmd('FileType', {
  pattern = { 'cmd', 'msg', 'pager', 'dialog' },
  callback = function()
    vim.opt_local.winblend = 0
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    local whl = {
      cmd    = 'NormalFloat:Normal,FloatBorder:Function',
      msg    = 'NormalFloat:Normal,FloatBorder:String',
      pager  = 'NormalFloat:Normal,FloatBorder:Keyword',
      dialog = 'NormalFloat:Normal,FloatBorder:Type',
    }
    vim.wo.winhighlight = whl[vim.bo.filetype] or ''
  end,
})
