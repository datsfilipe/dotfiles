{ pkgs, vars, lib, ... }:

let theme = (import ../../modules/colorscheme).theme;
in {
  xdg.configFile."alacritty/alacritty.yml".text = ''
    ${lib.fileContents ../../dotfiles/alacritty.yml}
  '';

  xdg.configFile."alacritty/colors.yml".text = ''
    colors:
      primary:
        background: "${theme.scheme.colors.bg}"
        foreground: "${theme.scheme.colors.fg}"

      normal:
        black: "${theme.scheme.colors.black}"
        red: "${theme.scheme.colors.red}"
        green: "${theme.scheme.colors.green}"
        yellow: "${theme.scheme.colors.yellow}"
        blue: "${theme.scheme.colors.blue}"
        magenta: "${theme.scheme.colors.magenta}"
        cyan: "${theme.scheme.colors.cyan}"
        white: "${theme.scheme.colors.white}"

      bright:
        black: "${theme.scheme.colors.black}"
        red: "${theme.scheme.colors.red}"
        green: "${theme.scheme.colors.green}"
        yellow: "${theme.scheme.colors.yellow}"
        blue: "${theme.scheme.colors.blue}"
        magenta: "${theme.scheme.colors.magenta}"
        cyan: "${theme.scheme.colors.cyan}"
        white: "${theme.scheme.colors.white}"
  '';
}
