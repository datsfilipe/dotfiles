{ inputs, pkgs, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
in {
  imports = [ inputs.ags.homeManagerModules.default ];

  home.packages = with pkgs; [
    (python311.withPackages (p: [ p.python-pam ]))
    sassc
  ];

  programs.ags = {
    enable = true;
    extraPackages = [ pkgs.libsoup_3 ];
  };

  xdg.configFile."ags" = {
    source = ../../dotfiles/ags;
    recursive = true;
  };

  xdg.configFile."ags/scss/variables.scss".text = ''
    $primary: ${theme.scheme.colors.primary};
    $bg: ${theme.scheme.colors.bg};
    $altbg: ${theme.scheme.colors.altbg};
    $fg: ${theme.scheme.colors.fg};
    $black: ${theme.scheme.colors.black};
    $red: ${theme.scheme.colors.red};
    $green: ${theme.scheme.colors.green};
    $yellow: ${theme.scheme.colors.yellow};
    $blue: ${theme.scheme.colors.blue};
    $magenta: ${theme.scheme.colors.magenta};
    $cyan: ${theme.scheme.colors.cyan};
    $white: ${theme.scheme.colors.white};
  '';
}
