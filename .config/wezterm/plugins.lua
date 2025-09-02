local wezterm = require("wezterm") --[[@as Wezterm]]

local M = {}

---@param config Config
function M.apply_to_config(config)
  -- various tab bar plugins
  -- wezterm.plugin
  --       .require('https://github.com/yriveiro/wezterm-tabs')
  --       .apply_to_config(config, { tabs = { tab_bar_at_bottom = true } })

  -- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
  -- bar.apply_to_config(config, 
  --   {
  --     position = "bottom",
  --     max_width = 24,
  --     padding = {
  --       left = 0,
  --       right = 1,
  --       tabs = {
  --         left = 1,
  --         right = 1
  --       }
  --     },
  --     separator = {
  --       space = 1,
  --       left_icon = wezterm.nerdfonts.pl_left_soft_divider,
  --       right_icon = wezterm.nerdfonts.pl_right_soft_divider,
  --       field_icon = wezterm.nerdfonts.indent_line,
  --     },
  --     modules = {
  --       workspace = {
  --         enabled = false,
  --       },
  --       pane = {
  --         enabled = false,
  --       },
  --       username = {
  --         enabled = false,
  --       },
  --       hostname = {
  --         enabled = false,
  --       },
  --     },
  --   })

  -- Try loading tabline plugin with fresh cache
  local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
  tabline.setup({
    options = {
      icons_enabled = true,
      theme = 'Catppuccin Mocha',
      tabs_enabled = true,
      theme_overrides = {
        -- Default colors from Catppuccin Mocha
        normal_mode = {
          a = { fg = '#181825', bg = '#cba6f7' },
          b = { fg = '#cba6f7', bg = '#313244' },
          c = { fg = '#cdd6f4', bg = '#181825' },
        },
        copy_mode = {
          a = { fg = '#181825', bg = '#f9e2af' },
          b = { fg = '#f9e2af', bg = '#313244' },
          c = { fg = '#cdd6f4', bg = '#181825' },
        },
        search_mode = {
          a = { fg = '#181825', bg = '#a6e3a1' },
          b = { fg = '#a6e3a1', bg = '#313244' },
          c = { fg = '#cdd6f4', bg = '#181825' },
        },
        -- Defining colors for a new key table
        window_mode = {
          a = { fg = '#181825', bg = '#89b4fa' },
          b = { fg = '#89b4fa', bg = '#313244' },
          c = { fg = '#cdd6f4', bg = '#181825' },
        },
        -- Default tab colors
        tab = {
          active = { fg = '#cba6f7', bg = '#313244' },
          inactive = { fg = '#cdd6f4', bg = '#181825' },
          inactive_hover = { fg = '#f5c2e7', bg = '#313244' },
        }
      },
      section_separators = {
        left = wezterm.nerdfonts.ple_lower_left_triangle, -- hard_divider,
        right = wezterm.nerdfonts.ple_lower_right_triangle, -- hard_divider,
      },
      component_separators = {
        left = wezterm.nerdfonts.ple_backslash_separator, -- left_soft_divider,
        right = wezterm.nerdfonts.ple_forwardslash_separator, -- right_soft_divider,
      },
      tab_separators = {
        left = wezterm.nerdfonts.ple_lower_left_triangle, -- left_hard_divider,
        right = wezterm.nerdfonts.ple_upper_right_triangle, -- hard_divider,
      },
    },
    sections = {
      tabline_a = { ' 󰣇 ', 'mode' }, -- mode
      tabline_b = { }, -- workspace
      tabline_c = { },
      tab_active = {
        'index',
        wezterm.nerdfonts.ple_backslash_separator,
        { 'parent', padding = 0 },
        '/',
        { 'cwd', padding = { left = 0, right = 1 } },
        { 'zoomed', padding = 0 },
      },
      tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
      tabline_x = { 'workspace' }, -- { 'ram', 'cpu' },
      tabline_y = { 'datetime' },  -- { 'datetime', 'battery' },
      tabline_z = { }, -- { 'domain' },
    },
    extensions = {},
  })
  -- tabline.apply_to_config(config)
  

  -- local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
  -- modal.apply_to_config(config)

  -- local pain_control = wezterm.plugin.require("https://github.com/sei40kr/wez-pain-control").apply_to_config(config)

end

return M
