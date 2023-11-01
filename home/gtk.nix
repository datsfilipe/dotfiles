{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.graphite-gtk-theme;
      name = "Graphite-Dark";
    };
    # iconTheme = {
    #   package = pkgs.qogir-icon-theme;
    #   name = "Qogir-dark";
    # };
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
