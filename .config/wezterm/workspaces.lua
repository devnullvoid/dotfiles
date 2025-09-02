local wezterm = require("wezterm")

local function file_exists(name)
  local f = io.open(name, "r")
  return f ~= nil and io.close(f)
end

local M = {}

function M.setup()
  local host = wezterm.hostname()
  local workspaces = {}
  -- local workspace_file = wezterm.config_dir .. "/hosts/" .. host .. ".lua"
  --
  -- if file_exists(workspace_file) then
  --   workspaces = require("hosts." .. host).workspaces
  -- end

  -- wezterm.on("gui-startup", function(cmd)
  --   if #workspaces == 0 then
  --     local tab, pane, window = wezterm.mux.spawn_window(cmd or { workspace = "default" })
  --     pane:split { direction = 'Top', size = 0.5 }
  --   end
  -- end)
  --
  -- wezterm.on("window-config-reloaded", function(window, pane)
  --   local tab = window:active_tab()
  --   if tab then
  --     local panes = tab:panes()
  --     if #panes == 1 then
  --       panes[1]:split { direction = "Top", size = 0.5 }
  --     end
  --   end
  -- end)
  --
  -- wezterm.on("mux-new-window", function(window, pane)
  --   pane:split { direction = "Top", size = 0.5 }
  -- end)
  --
  -- wezterm.on("mux-startup", function()
  --   for _, workspace in ipairs(workspaces) do
  --     local tab, pane, window = wezterm.mux.spawn_window {
  --       workspace = workspace.name,
  --       cwd = workspace.directory,
  --     }
  --     pane:split { direction = "Top", size = 0.5 }
  --   end
  -- end)

  -- Handle new tabs
  local checked_tabs = {}
  wezterm.on("update-right-status", function(window, pane)
    local tab = window:active_tab()
    if tab then
      local tab_id = tab:tab_id()
      local panes = tab:panes()
      
      if #panes == 1 and not checked_tabs[tab_id] then
        checked_tabs[tab_id] = true
        panes[1]:split { direction = "Top", size = 0.5 }
      end
    end
  end)
end

return M
