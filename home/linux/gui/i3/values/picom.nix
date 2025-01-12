{ lib, mylib, pkgs, ... }: {
  modules.desktop.conf.picom.settings = {
    backend = "glx";
    fade = true;
    fade-delta = 2;
    inactive-opacity = 0.9;
    opacity-rule = [
      "100:class_g = 'chromium-browser' && name %= '*- YouTube*'"
    ];
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
      "name = 'win'"
    ];

    corner-radius = 0;
    round-borders = 0;
    rounded-corners-exclude = [
      "name = 'Notification'"
      "class_g ?= 'Notify-osd'"
      "class_g = 'Polybar'"
      "class_g = 'Rofi'"
      "window_type = 'tooltip'"
      "name = 'win'"
    ];
    blur-background-exclude = [
      "name = 'win'"
    ];
    focus-exclude = [
      "name = 'win'"
    ];
  };

  xsession.windowManager.i3.config = {
    startup = [
      {
        command = "DISPLAY=:0 ${pkgs.picom}/bin/picom -f --config $HOME/.config/picom/picom.conf";
        always = true;
      }
    ];
  };

  home.packages = with pkgs; [ picom ];
}
