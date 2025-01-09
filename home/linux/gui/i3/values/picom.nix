{ lib, mylib, pkgs, ... }: let
  picomConf = {
    backend = "glx";
    fade = true;
    fade-delta = 2;
    inactive-opacity = 0.9;
    shadow = true;
    shadow-offset-x = -9;
    shadow-offset-y = -9;
    shadow-opacity = 0.25;
    shadow-radius = 10;
    shadow-exclude = [
      "name = 'Notification'"
      "class_g ?= 'Notify-osd'"
      "class_g ?= 'Polybar'"
      "class_g ?= 'Rofi'"
      "_GTK_FRAME_EXTENTS"
    ];

    corner-radius = 4;
    round-borders = 1;
    rounded-corners-exclude = [
      "name = 'Notification'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Polybar'"
      "class_g = 'Rofi'"
      "window_type = 'tooltip'"
    ];
  };
in {
  home.packages = with pkgs; [ picom ];

  xdg.configFile."picom/picom.conf".text = mylib.format.sections [] picomConf;

  xsession.windowManager.i3.config = {
    startup = [
      {
        command = "DISPLAY=:0 ${pkgs.picom}/bin/picom -f --config $HOME/.config/picom/picom.conf";
        always = true;
      }
    ];
  };
}
