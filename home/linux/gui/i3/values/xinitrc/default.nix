{ pkgs, lib, ... }: with lib; {
  home.file.".xinitrc".text = ''
    ${fileContents ./conf/mergex-conf.sh}

    exec ${pkgs.picom}/bin/picom -f &
    exec ${pkgs.i3}/bin/i3
  '';
}
