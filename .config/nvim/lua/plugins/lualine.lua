return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }
      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end,
  },
}
-- SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ('', '')
-- LEFT_SEPARATOR_SYMBOL, LEFT_SOFT_SEPARATOR_SYMBOL = ('', '')
-- DIVIDER, SOFT_DIVIDER = ('', '') #('', '')
-- RIGHT_DIVIDER, RIGHT_SOFT_DIVIDER = ('', '') #('', '')
