{ pkgs, vars, ... }:

let colors = import ../modules/colorschemes.nix;
in {
  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require("wezterm")  
    local config = {}

    -- In newer versions of wezterm, use the config_builder which will
    -- help provide clearer error messages
    if wezterm.config_builder then
      config = wezterm.config_builder()
    end

    config.color_schemes = {
      ["eva"] = require("eva"),
    }
    config.color_scheme = "eva";
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

    config.window_background_opacity = 0.9
    config.text_background_opacity = 0.95

    config.tab_bar_at_bottom = true
    config.use_fancy_tab_bar = false
    config.window_decorations = "RESIZE"

    config.font = wezterm.font("JetBrainsMono Nerd Font")

    config.audible_bell = "Disabled"

    return config
  '';

  xdg.configFile."wezterm/eva.lua".text = ''
    return {
      background = "${colors.scheme.eva.bg}",
      foreground = "${colors.scheme.eva.fg}",
      cursor_bg = "${colors.scheme.eva.fg}",
      cursor_fg = "${colors.scheme.eva.black}",
      cursor_border = "${colors.scheme.eva.fg}",
      selection_fg = "${colors.scheme.eva.black}",
      selection_bg = "${colors.scheme.eva.fg}",
      scrollbar_thumb = "${colors.scheme.eva.fg}",
      split = "${colors.scheme.eva.white}",
      ansi = {
        "${colors.scheme.eva.bg}",
        "${colors.scheme.eva.red}",
        "${colors.scheme.eva.green}",
        "${colors.scheme.eva.yellow}",
        "${colors.scheme.eva.blue}",
        "${colors.scheme.eva.magenta}",
        "${colors.scheme.eva.cyan}",
        "${colors.scheme.eva.fg}",
      },
      brights = {
        "${colors.scheme.eva.white}",
        "${colors.scheme.eva.red}",
        "${colors.scheme.eva.green}",
        "${colors.scheme.eva.yellow}",
        "${colors.scheme.eva.blue}",
        "${colors.scheme.eva.magenta}",
        "${colors.scheme.eva.cyan}",
        "${colors.scheme.eva.bg}",
      },
    }
  '';
}
