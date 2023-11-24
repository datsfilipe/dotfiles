{ pkgs, vars, ... }:

let theme = (import ../../modules/colorscheme).theme;
in {
  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require("wezterm")  
    local config = {}

    if wezterm.config_builder then
      config = wezterm.config_builder()
    end

    config.color_schemes = {
      ["datstheme"] = require("theme"),
    }
    config.color_scheme = "datstheme";
    config.default_prog = { "tmux" }
    config.window_close_confirmation = "NeverPrompt"
    config.hide_tab_bar_if_only_one_tab = true

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

    config.audible_bell = "Disabled"

    return config
  '';

  xdg.configFile."wezterm/theme.lua".text = ''
    return {
      background = "${theme.scheme.colors.bg}",
      foreground = "${theme.scheme.colors.fg}",
      cursor_bg = "${theme.scheme.colors.fg}",
      cursor_fg = "${theme.scheme.colors.black}",
      cursor_border = "${theme.scheme.colors.fg}",
      selection_fg = "${theme.scheme.colors.black}",
      selection_bg = "${theme.scheme.colors.fg}",
      scrollbar_thumb = "${theme.scheme.colors.fg}",
      split = "${theme.scheme.colors.white}",
      ansi = {
        "${theme.scheme.colors.bg}",
        "${theme.scheme.colors.red}",
        "${theme.scheme.colors.green}",
        "${theme.scheme.colors.yellow}",
        "${theme.scheme.colors.blue}",
        "${theme.scheme.colors.magenta}",
        "${theme.scheme.colors.cyan}",
        "${theme.scheme.colors.fg}",
      },
      brights = {
        "${theme.scheme.colors.white}",
        "${theme.scheme.colors.red}",
        "${theme.scheme.colors.green}",
        "${theme.scheme.colors.yellow}",
        "${theme.scheme.colors.blue}",
        "${theme.scheme.colors.magenta}",
        "${theme.scheme.colors.cyan}",
        "${theme.scheme.colors.bg}",
      },
    }
  '';
}
