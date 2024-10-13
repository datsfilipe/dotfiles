{ vars, ... }:

{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/${vars.user}/.config/wallpaper.png";
    };
  };

  home.file.".Xresources".text = ''
    *dpi: ${vars.system.dpi}
    Xft.dpi: ${vars.system.dpi}
  '';
}
