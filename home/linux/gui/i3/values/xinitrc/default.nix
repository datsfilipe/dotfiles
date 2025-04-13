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
    exec ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
      exec ${pkgs.i3}/bin/i3
  '';
}
