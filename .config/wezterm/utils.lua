local wezterm = require("wezterm") --[[@as Wezterm]]
M = {}

-- local colors = wezterm.color.get_builtin_schemes()["catppuccin-mocha"]

-- M.colors = colors

M.colors = {
		rosewater = "#f5e0dc",
		flamingo = "#f2cdcd",
		pink = "#f5c2e7",
		mauve = "#cba6f7",
		red = "#f38ba8",
		maroon = "#eba0ac",
		peach = "#fab387",
		yellow = "#f9e2af",
		green = "#a6e3a1",
		teal = "#94e2d5",
		sky = "#89dceb",
		sapphire = "#74c7ec",
		blue = "#89b4fa",
		lavender = "#b4befe",
		text = "#cdd6f4",
		subtext1 = "#bac2de",
		subtext0 = "#a6adc8",
		overlay2 = "#9399b2",
		overlay1 = "#7f849c",
		overlay0 = "#6c7086",
		surface2 = "#585b70",
		surface1 = "#45475a",
		surface0 = "#313244",
		base = "#1e1e2e",
		mantle = "#181825",
		crust = "#11111b"
}
---@param window Window
---@return string
function M.get_current_mode(window)
  local _, is_leader = pcall(function()
    return window:leader_is_active()
  end)
  if is_leader then
    return "LEADER"
  end
  local _, key_table = pcall(function()
    return window:active_key_table()
  end)
  key_table = key_table or "normal_mode"

  if not key_table:find("_mode$") then
    key_table = "normal_mode"
  end
  return key_table:gsub("_mode", ""):upper()
end

return M
