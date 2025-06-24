local wezterm = require("wezterm") --[[@as Wezterm]]
local mux = wezterm.mux

local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local function setup_workspace(workspace)
  local tab, pane, window = mux.spawn_window {
    workspace = workspace.name,
    cwd = workspace.directory,
  }
  local layout_fn = workspace.layout or function(window, tab, pane) end
  layout_fn(window, tab, pane)
end

local M = {}

function M.setup()
  local host = wezterm.hostname()
  local workspaces
  local workspace_file = wezterm.config_dir .. "/hosts/" .. host .. ".lua"
  if file_exists(workspace_file) then
    workspaces = require("hosts." .. host).workspaces
  else
    workspaces = {}
  end
  wezterm.on("mux-startup", function()
    for _, workspace in ipairs(workspaces) do
      setup_workspace(workspace)
    end
  end)
  wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():set_inner_size(2200, 1400)
  end)
end
return M
