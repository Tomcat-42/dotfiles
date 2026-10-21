require("clangd_extensions").setup({
  ast = {
    role_icons = {
      type = "[T]",
      declaration = "[D]",
      expression = "[E]",
      statement = "[S]",
      specifier = "[s]",
      ["template argument"] = "[T]",
    },
    kind_icons = {
      Compound = "[C]",
      Recovery = "[R]",
      TranslationUnit = "[U]",
      PackExpansion = "[P]",
      TemplateTypeParm = "[T]",
      TemplateTemplateParm = "[T]",
      TemplateParamObject = "[T]",
    },
    highlights = {
      detail = "Comment",
    },
  },
  memory_usage = {
    border = "single",
  },
  symbol_info = {
    border = "single",
  },
})
