local wezterm = require("wezterm") --[[@as Wezterm]]

local config = wezterm.config_builder()

-- needs to be set here to take effect on startup
config.use_fancy_tab_bar = false

require("options").apply_to_config(config)
require("keys").apply_to_config(config)
-- -- require("workspaces").setup()
-- -- require("tabbar").apply_to_config(config)
require("plugins").apply_to_config(config)

return config
