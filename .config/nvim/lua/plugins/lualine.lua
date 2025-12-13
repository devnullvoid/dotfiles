return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }

      -- Custom theme with swapped normal/visual colors using catppuccin palette
      local custom_theme = {
        normal = {
          a = { fg = "#1e1e2e", bg = "#cba6f7", gui = "bold" },
          b = { fg = "#cba6f7", bg = "#313244" },
          c = { fg = "#cdd6f4", bg = "#1e1e2e" },
        },
        visual = {
          a = { fg = "#1e1e2e", bg = "#89b4fa", gui = "bold" },
          b = { fg = "#89b4fa", bg = "#313244" },
          c = { fg = "#cdd6f4", bg = "#1e1e2e" },
        },
        insert = {
          a = { fg = "#1e1e2e", bg = "#a6e3a1", gui = "bold" },
          b = { fg = "#a6e3a1", bg = "#313244" },
          c = { fg = "#cdd6f4", bg = "#1e1e2e" },
        },
        replace = {
          a = { fg = "#1e1e2e", bg = "#f38ba8", gui = "bold" },
          b = { fg = "#f38ba8", bg = "#313244" },
          c = { fg = "#cdd6f4", bg = "#1e1e2e" },
        },
        command = {
          a = { fg = "#1e1e2e", bg = "#fab387", gui = "bold" },
          b = { fg = "#fab387", bg = "#313244" },
          c = { fg = "#cdd6f4", bg = "#1e1e2e" },
        },
        inactive = {
          a = { fg = "#6c7086", bg = "#1e1e2e" },
          b = { fg = "#6c7086", bg = "#1e1e2e" },
          c = { fg = "#6c7086", bg = "#1e1e2e" },
        },
      }

      opts.options.theme = custom_theme

      table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    end,
  },
}
-- SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ('', '')
-- LEFT_SEPARATOR_SYMBOL, LEFT_SOFT_SEPARATOR_SYMBOL = ('', '')
-- DIVIDER, SOFT_DIVIDER = ('', '') #('', '')
-- RIGHT_DIVIDER, RIGHT_SOFT_DIVIDER = ('', '') #('', '')
