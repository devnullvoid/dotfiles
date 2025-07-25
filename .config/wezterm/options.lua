local wezterm = require("wezterm") --[[@as Wezterm]]
local utils = require("utils")
local M = {}

local monaspace_krypton = wezterm.font { family = "Monaspace Krypton", harfbuzz_features= { "cv01=2" }, }
local monaspace_neon = wezterm.font { family = "Monaspace Neon", harfbuzz_features= { "cv01=2" }, }
local monaspace_argon = wezterm.font { family = "Monaspace Argon", harfbuzz_features= { "cv01=2" }, }
local monaspace_radon = wezterm.font { family = "Monaspace Radon", harfbuzz_features= { "cv01=2" }, }
local monaspace_krypton_bold = wezterm.font { family = "Monaspace Krypton", weight = "Bold", harfbuzz_features= { "cv01=2" }, }
local monaspace_neon_bold = wezterm.font { family = "Monaspace Neon", weight = "Bold", harfbuzz_features= { "cv01=2" }, }
local monaspace_argon_bold = wezterm.font { family = "Monaspace Argon", weight = "Bold", harfbuzz_features= { "cv01=2" }, }
local monaspace_radon_bold = wezterm.font { family = "Monaspace Radon", weight = "Bold", harfbuzz_features= { "cv01=2" }, }

function M.apply_to_config(config)
  config.font_size = 11
  config.font = monaspace_krypton -- = wezterm.font_with_fallback { "Monaspace Krypton", "Symbols Nerd Font Mono" }
  config.font_rules = {
    {
      intensity = 'Bold',
      italic = true,
      font = monaspace_radon_bold,
    },
    {
      intensity = 'Normal',
      italic = true,
      font = monaspace_radon,
    },
    {
      intensity = 'Bold',
      italic = false,
      font = monaspace_krypton_bold,
    },
  }
  -- config.window_decorations = "RESIZE"
  config.default_domain = "local"
  config.unix_domains = { {
    name = "unix",
    connect_automatically = true,
  } }
  config.color_scheme = "Catppuccin Mocha"
  config.command_palette_fg_color = utils.colors.text
  config.command_palette_bg_color = utils.colors.surface0
  config.command_palette_font = monaspace_argon
  config.command_palette_font_size = 11
  config.tab_bar_at_bottom = true
  config.colors = {
    indexed = {
      [16] = utils.colors.base, -- No clue why, but fixes ipython colors (https://github.com/catppuccin/wezterm/issues/15)
    },
    tab_bar = {
      inactive_tab_edge = utils.colors.mantle,
      active_tab = { bg_color = utils.colors.mauve, fg_color = utils.colors.base },
      inactive_tab = { bg_color = utils.colors.base, fg_color = utils.colors.text },
      inactive_tab_hover = { bg_color = utils.colors.surface0, fg_color = utils.colors.text },
      new_tab = { bg_color = utils.colors.base, fg_color = utils.colors.text },
      new_tab_hover = { bg_color = utils.colors.surface0, fg_color = utils.colors.text },
    },
  }
end

return M
