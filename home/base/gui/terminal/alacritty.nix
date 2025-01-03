{ vars, lib, ... }:

with lib; {
  programs.alacritty.enable = true;

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
