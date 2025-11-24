{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.addons.gtk.user;
in {
  options.modules.desktop.addons.gtk.user.enable = mkEnableOption "GTK/theme defaults";

  config = mkIf cfg.enable {
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
        name = "Inter";
        package = pkgs.inter;
        size = 12;
      };

      gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-decoration-layout = "";
      };
    };

    home.sessionVariables = {
      GTK_THEME = "${config.gtk.theme.name}:dark";
    };

    dconf.settings."org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = config.gtk.theme.name;
    };
  };
}
