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
          displayManager.sessionCommands = ''
            systemctl --user import-environment DISPLAY XAUTHORITY PATH
          '';

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

        picom = {
          enable = true;
          backend = "glx";
          fade = true;
          fadeDelta = 5;
          inactiveOpacity = 0.9;
          settings = {
            shadow = true;
            shadow-offset-x = -9;
            shadow-offset-y = -9;
            shadow-opacity = 0.25;
            shadow-radius = 10;
            shadow-exclude = [
              "name = 'Notification'"
              "class_g ?= 'Notify-osd'"
              "class_g ?= 'Polybar'"
              "class_g ?= 'Rofi'"
              "_GTK_FRAME_EXTENTS@:c"
            ];

            corner-radius = 4;
            round-borders = 1;
            rounded-corners-exclude = [
              "name = 'Notification'"
              "class_g ?= 'Notify-osd'"
              "class_g = 'Polybar'"
              "class_g = 'Rofi'"
              "window_type = 'tooltip'"
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
