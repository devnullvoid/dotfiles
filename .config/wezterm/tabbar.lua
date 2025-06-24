local wezterm = require("wezterm") --[[@as Wezterm]]
local symbols = wezterm.nerdfonts
local utils = require("utils")

local mode_colors = {
  NORMAL = utils.colors.blue,
  COPY = utils.colors.yellow,
  SEARCH = utils.colors.green,
  LEADER = utils.colors.red,
}

wezterm.on("update-status", function(window, pane)
  local mode_color = mode_colors[utils.get_current_mode(window)]
  if mode_color == nil then
    mode_color = mode_colors["NORMAL"]
  end
  local _, domain_name = pcall(function()
    return pane:get_domain_name()
  end)
  domain_name = type(domain_name) == "string" and domain_name or "Unknown"
  local domain = wezterm.format {
    { Foreground = { Color = utils.colors.subtext1 } },
    { Background = { Color = utils.colors.surface0 } },
    { Text = " " .. symbols.md_domain .. " " .. domain_name .. " " },
  }
  local workspace = wezterm.format {
    { Foreground = { Color = utils.colors.subtext1 } },
    { Background = { Color = utils.colors.surface1 } },
    { Text = " " .. symbols.cod_terminal_tmux .. " " .. window:active_workspace() .. " " },
  }
  local host = wezterm.format {
    { Foreground = { Color = utils.colors.base } },
    { Background = { Color = mode_color } },
    { Text = " " .. symbols.md_network_pos .. " " .. wezterm.hostname() .. " " },
  }
  window:set_right_status(domain .. workspace .. host)
end)

function M.apply_to_config(config)
  config.use_fancy_tab_bar = false
  config.window_frame = {
    font = wezterm.font { family = "Monaspace Radon", weight = "Bold" },
    font_size = 11.0,
    active_titlebar_bg = utils.colors.mantle,
    inactive_titlebar_bg = utils.colors.mantle,
  }
  return config
end

return M
