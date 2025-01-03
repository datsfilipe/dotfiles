{
  pkgs,
  config,
  ...
}: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Quintom_Snow";
    package = pkgs.quintom-cursor-theme;
    size = 24;
  };

  xresources.properties = {
    "Xft.dpi" = 96;
    "*.dpi" = 96;
  };

  gtk = {
    enable = true;

    font = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
      size = 11;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    # theme = {
    #   name = theme.gtk-theme.name;
    #   package = pkgs."${theme.gtk-theme.package}";
    # };
  };
}
