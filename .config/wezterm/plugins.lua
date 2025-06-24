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
      padding = {
        tabs = {
          left = 1,
          right = 1
        }
      }
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
