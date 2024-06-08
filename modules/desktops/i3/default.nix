{ config, pkgs, ... }:

let exec = "startx";
in {
  services = {
    displayManager = {
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          xorg.xinit
          xorg.xrandr
          xorg.setxkbmap
          feh
          flameshot
          xclip
          i3status
          i3lock
          dconf
       ];
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
