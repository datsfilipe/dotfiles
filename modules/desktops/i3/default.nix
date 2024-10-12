{ config, lib, vars, pkgs, ... }:

with lib; let exec = "startx";
in mkIf (vars.environment.desktop == "i3") {
  services = {
    displayManager = {
      defaultSession = "none+i3";
    };

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
      };
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
