local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_schemes = {
	["datstheme"] = require("theme"),
}
config.color_scheme = "datstheme"
config.default_prog = { "bash", "-c", "zellij attach dtsf -c" }
config.window_close_confirmation = "NeverPrompt"
config.hide_tab_bar_if_only_one_tab = true
config.enable_wayland = false
config.enable_tab_bar = false

config.window_padding = {
	top = "1cell",
	right = "2cell",
	bottom = "1cell",
	left = "2cell",
}

config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.8,
}

config.window_background_opacity = 0.75
config.text_background_opacity = 1.0

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font_size = 14.0

config.audible_bell = "Disabled"

return config
