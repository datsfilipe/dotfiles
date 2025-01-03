{ lib, pkgs, ... }:

with lib; let
  exec = "startx";
  pkg = pkgs.i3;
in {
  services = {
    desktopManager.default = "none";
    displayManager = {
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;
      autorun = false;
      exportConfiguration = true;
      windowManager.i3 = {
        enable = true;
        package = pkg;
      };
    };
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';
  };
}
