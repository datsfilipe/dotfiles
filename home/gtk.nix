{ pkgs, ... }:

let
  theme = (import ../modules/colorscheme).theme;
in {
  gtk = {
    enable = true;
    theme = {
      name = theme.gtk-theme.name;
      package = pkgs."${theme.gtk-theme.package}";
    };
    font.name = "Inter";
    font.size = 10;
  };

  home.pointerCursor = {
    name = "Quintom_Snow";
    package = pkgs.quintom-cursor-theme;
    size = 24;
    gtk.enable = true;
  };
}
