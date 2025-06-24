local wezterm = require("wezterm") --[[@as Wezterm]]
local action = wezterm.action
local user_action = require("actions")

local M = {}

---@param config Config
function M.apply_to_config(config)
  -- config.disable_default_key_bindings = true
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
  config.keys = {
    { key = "\\", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "Space", mods = "LEADER|CTRL", action = wezterm.action.SendKey { key = "Space", mods = "CTRL" } },
  {
      key = 'a',
      mods = 'LEADER|CTRL',
      action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
    {
      key = "L",
      mods = "CTRL",
      action = action.ShowLauncherArgs { flags = "FUZZY|LAUNCH_MENU_ITEMS", title = "Launch Menu" },
    },
    {
      key = "a",
      mods = "LEADER",
      action = action.ShowLauncherArgs { flags = "FUZZY|DOMAINS", title = "DOMAINS" },
    },
    { key = "P", mods = "CTRL", action = "ActivateCommandPalette" },
    { key = "Q", mods = "CTRL", action = "QuitApplication" },
    { key = "R", mods = "CTRL", action = "ReloadConfiguration" },
    {
      key = "s",
      mods = "LEADER",
      action = action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES", title = "Select workspace" },
    },
    {
      key = "s",
      mods = "LEADER|SHIFT",
      action = user_action.select_workspace,
    },
    {
      key = "N",
      mods = "LEADER",
      action = user_action.rename_workspace,
    },
    {
      key = "n",
      mods = "LEADER",
      action = user_action.rename_tab,
    },

    -- Default Keybindings
    { key = "l", mods = "ALT", action = action.ActivateTabRelative(1) },
    { key = "h", mods = "ALT", action = action.ActivateTabRelative(-1) },
    { key = "+", mods = "CTRL", action = "IncreaseFontSize" },
    { key = "-", mods = "CTRL", action = "DecreaseFontSize" },
    { key = "-", mods = "SUPER", action = "DecreaseFontSize" },
    { key = "0", mods = "CTRL", action = "ResetFontSize" },
    { key = "0", mods = "SUPER", action = "ResetFontSize" },
    { key = "C", mods = "CTRL", action = action.CopyTo("Clipboard") },
    { key = "F", mods = "CTRL", action = action.Search("CurrentSelectionOrEmptyString") },
    { key = "M", mods = "CTRL", action = "Hide" },
    {
      key = "U",
      mods = "CTRL",
      action = action.CharSelect { copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" },
    },
    { key = "V", mods = "CTRL", action = action.PasteFrom("Clipboard") },
    { key = "W", mods = "SUPER|SHIFT", action = action.CloseCurrentTab { confirm = true } },
    { key = "E", mods = "SUPER", action = action.CloseCurrentPane { confirm = true } },
    { key = "X", mods = "CTRL", action = "ActivateCopyMode" },
    { key = "Z", mods = "CTRL", action = "TogglePaneZoomState" },
    { key = "c", mods = "SUPER", action = action.CopyTo("Clipboard") },
    { key = "f", mods = "SUPER", action = action.Search("CurrentSelectionOrEmptyString") },
    { key = "h", mods = "SUPER", action = "HideApplication" },
    { key = "k", mods = "SUPER", action = action.ClearScrollback("ScrollbackOnly") },
    { key = "m", mods = "SUPER", action = "Hide" },
    { key = "q", mods = "SUPER", action = "QuitApplication" },
    { key = "r", mods = "SUPER", action = "ReloadConfiguration" },
    { key = "v", mods = "SUPER", action = action.PasteFrom("Clipboard") },
    { key = "v", mods = "ALT", action = action.PasteFrom("PrimarySelection") },
    { key = "k", mods = "LEADER|SHIFT", action = action.CloseCurrentTab { confirm = true } },
    { key = "k", mods = "LEADER", action = action.CloseCurrentPane { confirm = true } },
    { key = "t", mods = "LEADER", action = action.SpawnTab("CurrentPaneDomain") },
    { key = "/", mods = "SHIFT|CTRL", action = wezterm.action.QuickSelect },
    {
      key = "h",
      mods = "CTRL",
      action = user_action.move.left,
    },
    {
      key = "j",
      mods = "CTRL",
      action = user_action.move.down,
    },
    {
      key = "k",
      mods = "CTRL",
      action = user_action.move.up,
    },
    {
      key = "l",
      mods = "CTRL",
      action = user_action.move.right,
    },
    {
      key = "I",
      mods = "LEADER",
      action = action.PaneSelect {
        show_pane_ids = true,
      },
    },
    {
      key = "m",
      mods = "LEADER",
      action = action.PaneSelect {
        mode = "SwapWithActive",
      },
    },
    {
      key = "P",
      mods = "LEADER",
      action = user_action.set_paste_terminal,
    },
    {
      key = "p",
      mods = "LEADER",
      action = user_action.paste_selection,
    },
    { key = "D", mods = "LEADER", action = action.ShowDebugOverlay },
  }
  config.mouse_bindings = {
    -- Ctrl-click will open the link under the mouse cursor
    {
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
  }
end

return M
