{ pkgs, lib, ... }: with lib; {
  home.file.".xinitrc".text = ''
    ${fileContents ./conf/mergex-conf.sh}

    ${fileContents ./conf/services.sh}

    exec ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr &
    exec ${pkgs.i3}/bin/i3
  '';
}
