{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.addons.gtk.user;

  hostMonitors = config.modules.hardware.monitors.monitors or [];
  focusedMonitors = builtins.filter (m: m.focus or false) hostMonitors;
  primaryScale =
    if focusedMonitors != []
    then builtins.fromJSON (builtins.head focusedMonitors).scale
    else if hostMonitors != []
    then builtins.fromJSON (builtins.head hostMonitors).scale
    else 1.0;
  scaledDpi = builtins.floor ((96.0 * primaryScale) + 0.5);
in {
  options.modules.desktop.addons.gtk.user.enable = mkEnableOption "GTK/theme defaults";

  config = mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      x11.enable = true;
      name = "Quintom_Snow";
      package = pkgs.quintom-cursor-theme;
      size = 24;
    };

    xresources.properties = {
      "Xft.dpi" = scaledDpi;
      "*.dpi" = scaledDpi;
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
