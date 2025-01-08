{ pkgs, lib, ... }: with lib; {
  home.file.".xinitrc".text = ''
    ${fileContents ./conf/mergex-conf.sh}

    exec ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
    exec ${pkgs.picom}/bin/picom -f &
    exec ${pkgs.i3}/bin/i3
  '';
}
