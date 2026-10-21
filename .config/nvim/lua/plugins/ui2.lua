require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'cmd',
    dialog = {
      height = 0.5,
    },
    pager = {
      height = 0.999,
    },
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cmd", "msg", "pager", "dialog" },
  callback = function()
    local whl = {
      cmd    = "NormalFloat:Normal,FloatBorder:Function",
      msg    = "NormalFloat:Normal,FloatBorder:String",
      pager  = "NormalFloat:Normal,FloatBorder:Keyword",
      dialog = "NormalFloat:Normal,FloatBorder:Type",
    }
    vim.opt_local.winblend = 0
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.wo.winhighlight = whl[vim.bo.filetype] or ""
  end,
})
