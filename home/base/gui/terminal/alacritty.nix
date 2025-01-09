{ lib, ... }:

with lib; {
  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell.program = "fish";

      font = {
        size = 14;
        bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        bold_italic = { family = "JetBrainsMono Nerd Font"; style = "Bold Italic"; };
      };

      cursor = {
        style = { shape = "Block"; blinking = "On"; };
        blink_interval = 500;
      };

      keyboard.bindings = [
        { key = "X"; mods = "Control"; action = "ToggleViMode"; }
      ];

      window = {
        opacity = 0.8;
        padding.x = 25;
        padding.y = 25;
      };
    };
  };

  # xdg.configFile."alacritty/alacritty.toml".text = ''
  #   ${fileContents ../../dotfiles/alacritty.toml}
  # '';

  # xdg.configFile."alacritty/colors.toml".text = ''
  #   [colors.bright]
  #   black = "${theme.scheme.colors.black}"
  #   red = "${theme.scheme.colors.red}"
  #   green = "${theme.scheme.colors.green}"
  #   yellow = "${theme.scheme.colors.yellow}"
  #   blue = "${theme.scheme.colors.blue}"
  #   magenta = "${theme.scheme.colors.magenta}"
  #   cyan = "${theme.scheme.colors.cyan}"
  #   white = "${theme.scheme.colors.white}"
  #
  #   [colors.normal]
  #   black = "${theme.scheme.colors.black}"
  #   red = "${theme.scheme.colors.red}"
  #   green = "${theme.scheme.colors.green}"
  #   yellow = "${theme.scheme.colors.yellow}"
  #   blue = "${theme.scheme.colors.blue}"
  #   magenta = "${theme.scheme.colors.magenta}"
  #   cyan = "${theme.scheme.colors.cyan}"
  #   white = "${theme.scheme.colors.white}"
  #
  #   [colors.primary]
  #   background = "${theme.scheme.colors.bg}"
  #   foreground = "${theme.scheme.colors.fg}"
  # '';
}
