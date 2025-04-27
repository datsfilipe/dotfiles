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

  niriSession = pkgs.writeShellScriptBin "custom-niri-session" ''
    if systemctl --user -q is-active niri.service; then
      echo 'a niri session is already running.'
      exit 1
    fi

    systemctl --user reset-failed

    if hash dbus-update-activation-environment 2>/dev/null; then
        dbus-update-activation-environment --all
    fi

    systemctl --user --wait start niri.service
    systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
    systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET
  '';
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
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      services = {
        xserver.enable = false;
      };

      programs.sway.wrapperFeatures.gtk = true;

      environment = {
        pathsToLink = ["/libexec"];
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec ${niriSession}/bin/custom-niri-session
          fi
        '';
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
        pathsToLink = ["/libexec"];
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec startx
          fi
        '';
      };
    })
  ];
}
