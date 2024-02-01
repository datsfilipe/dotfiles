local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_schemes = {
  ["datstheme"] = require("theme"),
}
config.color_scheme = "datstheme";
config.default_prog = { "bash", "-c", "tmux attach || tmux new-session -s dtsf" }
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = false

config.window_padding = {
  top = "2cell",
  right = "2cell",
  bottom = "2cell",
  left = "2cell",
}

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

config.window_background_opacity = 0.7
config.text_background_opacity = 1.0

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 13.0

config.audible_bell = "Disabled"

return config
