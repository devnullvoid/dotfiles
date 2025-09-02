local wezterm = require("wezterm")

return {
  workspaces = {
    {
      name = "test",
      directory = wezterm.home_dir,
      layout = function(window, tab, pane)
        pane:split { direction = "Top", size = 0.5 }
      end
    }
  }
}
