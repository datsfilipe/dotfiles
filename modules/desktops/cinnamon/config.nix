{ lib, vars, ... }:

lib.mkIf (vars.environment.desktop == "cinnamon") {
  dconf.settings = {
    "org/cinnamon/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/cinnamon/desktop/background" = {
      picture-uri = "file:///home/${vars.user}/.config/wallpaper.png";
      picture-uri-dark = "file:///home/${vars.user}/.config/wallpaper.png";
    };
  };
}
