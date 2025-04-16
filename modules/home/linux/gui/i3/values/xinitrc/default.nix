{
  pkgs,
  lib,
  ...
}:
with lib; {
  home.file.".xinitrc".text = ''
      ${fileContents ./conf/mergex-conf.sh}

    ${fileContents ./conf/services.sh}

    systemctl --user import-environment DISPLAY XAUTHORITY DBUS_SESSION_BUS_ADDRESS XDG_CURRENT_DESKTOP XDG_SESSION_TYPE WAYLAND_DISPLAY &

    nvidia-settings --assign \
      CurrentMetaMode="DP-0: nvidia-auto-select +0+420, HDMI-0: 1920x1080+1920+0 {rotation=left}" &

    exec ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
      exec ${pkgs.i3}/bin/i3
  '';
}
