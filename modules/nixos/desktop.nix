{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib; let
  cfgWayland = config.modules.desktop.wayland;
  cfgXorg = config.modules.desktop.xorg;
in {
  imports = [
    ./base
    ../base.nix

    ./desktop
  ];

  options.modules.desktop = {
    wayland = {
      enable = mkEnableOption "wayland display server";
    };
    xorg = {
      enable = mkEnableOption "xorg display server";
    };
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };

      services = {
        xserver.enable = false;
      };
    })

    (mkIf cfgXorg.enable {
      services = {
        gvfs.enable = true;

        libinput = {
          enable = true;
          mouse = {
            accelProfile = "flat";
            accelSpeed = "0";
          };
        };

        displayManager.defaultSession = "hm-session";
        xserver = {
          enable = true;
          xkb.layout = "us";
          displayManager.startx.enable = true;

          desktopManager = {
            xterm.enable = false;
            session = [
              {
                name = "hm-session";
                manage = "window";
                start = ''
                  ${pkgs.runtimeShell} $HOME/.xsession &
                  waitPID=$!
                '';
              }
            ];
          };
        };
      };

      environment = {
        pathsToLink = [ "/libexec" ];
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec startx
          fi
        '';
      };
    })
  ];
}
