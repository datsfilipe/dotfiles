{ inputs, pkgs, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
in {
  programs.rofi.enable = true;

  xdg.configFile."rofi" = {
    source = ../../dotfiles/rofi;
    recursive = true;
  };

  xdg.configFile."rofi/colors.rasi".text = ''
    @theme "/dev/null"

    * {
      bg: ${theme.scheme.colors.bg};
      fg: ${theme.scheme.colors.fg};
      al: ${theme.scheme.colors.primary};
      background-color: @bg;
      text-color: @fg;
    }
  '';
}
