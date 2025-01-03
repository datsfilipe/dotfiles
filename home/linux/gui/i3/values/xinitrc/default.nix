{ lib, ... }: with lib; {
  home.file.".xinitrc".text = ''
    ${fileContents ./conf/mergex-conf.sh}

    picom -f &
    exec i3
  '';
}
