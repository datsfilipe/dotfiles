{ lib, vars, ... }:

lib.mkIf (vars.environment.desktop == "gnome") {
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/${vars.user}/.config/wallpaper.png";
      picture-uri-dark = "file:///home/${vars.user}/.config/wallpaper.png";
    };
  };
}
