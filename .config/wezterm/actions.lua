local wezterm = require("wezterm") --[[@as Wezterm]]
local action = wezterm.action
local M = {}
M.rename_workspace = action.PromptInputLine {
  description = "Set workspace title:",
  action = wezterm.action_callback(function(win, pane, line)
    if line then
      wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
    end
  end),
}

M.rename_tab = action.PromptInputLine {
  description = "Enter new name for tab",
  action = wezterm.action_callback(function(window, pane, line)
    -- line will be `nil` if they hit escape without entering anything
    -- An empty string if they just hit enter
    -- Or the actual line of text they wrote
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

M.select_workspace = action.PromptInputLine {
  description = wezterm.format {
    { Attribute = { Intensity = "Bold" } },
    { Foreground = { AnsiColor = "Fuchsia" } },
    { Text = "Enter name for new workspace - Enter for Current Working Directory" },
  },
  action = wezterm.action_callback(function(window, pane, line)
    if line == "" then
      window:perform_action(
        action.SwitchToWorkspace {
          name = window:active_pane():get_current_working_dir(),
        },
        pane
      )
    elseif line ~= nil then
      window:perform_action(
        action.SwitchToWorkspace {
          name = line,
        },
        pane
      )
    end
  end),
}
---@param window Window
---@param pane Pane
---@param pane_direction Direction
---@param vim_direction string
local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  local vars = pane:get_user_vars()
  if vars.PROG == "nvim" or os.getenv("TMUX") then
    window:perform_action(
      -- This should match the keybinds you set in Neovim.
      action.SendKey { key = vim_direction, mods = "CTRL" },
      pane
    )
  else
    window:perform_action(action.ActivatePaneDirection(pane_direction), pane)
  end
end

M.move = {
  left = wezterm.action_callback(function(window, pane)
    conditionalActivatePane(window, pane, "Left", "h")
  end),
  right = wezterm.action_callback(function(window, pane)
    conditionalActivatePane(window, pane, "Right", "l")
  end),
  up = wezterm.action_callback(function(window, pane)
    conditionalActivatePane(window, pane, "Up", "k")
  end),
  down = wezterm.action_callback(function(window, pane)
    conditionalActivatePane(window, pane, "Down", "j")
  end),
}
local terminal = nil

M.set_paste_terminal = wezterm.action_callback(function(window, pane)
  local panes = window:active_tab():panes()
  local pane_list = {}

  for _, p in ipairs(panes) do
    local id = p:pane_id()
    local title = p:get_title()
    table.insert(pane_list, string.format("%s - %s", id, title))
  end

  window:perform_action(
    wezterm.action.PromptInputLine {
      description = "Select a Pane by ID:\n" .. table.concat(pane_list, "\n"),
      action = wezterm.action_callback(function(window, pane, id)
        if id and tonumber(id) then
          terminal = tonumber(id)
          wezterm.log_info("Pane Set", "Target pane set to ID: " .. id, nil, 3000)
        else
          wezterm.log_warn("Error", "Invalid pane ID entered", nil, 3000)
        end
      end),
    },
    pane
  )
end)

M.paste_selection = wezterm.action_callback(function(window, pane)
  local selection = window:get_selection_text_for_pane(pane)
  if terminal then
    local target_pane = wezterm.mux.get_pane(terminal)
    if target_pane then
      target_pane:send_paste(selection)
      window:perform_action(wezterm.action.SendKey { key = "Enter" }, target_pane)
    else
      wezterm.log_error("Invalid target pane ID: " .. tostring(terminal), nil, 3000)
    end
  else
    wezterm.log_error("No target pane set", nil, 3000)
  end
end)

return M
