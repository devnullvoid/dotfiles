local wezterm = require("wezterm") --[[@as Wezterm]]

local M = {}

---@param config Config
function M.apply_to_config(config)
  -- various tab bar plugins
  -- wezterm.plugin
  --       .require('https://github.com/yriveiro/wezterm-tabs')
  --       .apply_to_config(config, { tabs = { tab_bar_at_bottom = true } })

  local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
  bar.apply_to_config(config, 
    {
      position = "bottom",
      max_width = 24,
      padding = {
        left = 0,
        right = 1,
        tabs = {
          left = 1,
          right = 1
        }
      },
      separator = {
        space = 1,
        left_icon = wezterm.nerdfonts.pl_left_soft_divider,
        right_icon = wezterm.nerdfonts.pl_right_soft_divider,
        field_icon = wezterm.nerdfonts.indent_line,
      },
      modules = {
        workspace = {
          enabled = false,
        },
        pane = {
          enabled = false,
        },
        username = {
          enabled = false,
        },
        hostname = {
          enabled = false,
        },
      },
    })

  -- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
  -- tabline.setup({
  --   options = {
  --     theme = 'Catppuccin Mocha'
  --   }
  -- })
  -- tabline.apply_to_config(config)
  --
  -- local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
  -- modal.apply_to_config(config)

  -- local pain_control = wezterm.plugin.require("https://github.com/sei40kr/wez-pain-control").apply_to_config(config)

end

return M
