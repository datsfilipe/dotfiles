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
  cfgSessions = config.modules.desktop.sessions;

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
    systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET GDK_BACKEND
  '';

  sessionOptions = lib.concatStringsSep " " (map (s: ''"${s.name}"'') (lib.attrValues cfgSessions));
  sessionCases = lib.concatStringsSep "\n" (map (s: ''
    if [ "$choice" = "${s.name}" ]; then
      cmd='${s.command}'
      case "$cmd" in
        exec\ *) eval "$cmd" ;;
        *) exec ${pkgs.runtimeShell} -l -c "$cmd" ;;
      esac
    fi
  '') (lib.attrValues cfgSessions));

  guiSelector = pkgs.writeShellScriptBin "gui-select" ''
    set -eu
    IFS=$'\n\t'
    options=(${sessionOptions})
    if ! command -v ${pkgs.gum}/bin/gum >/dev/null 2>&1; then
      echo "gum not installed. Falling back to first session."
      ${
      if (lib.length (lib.attrValues cfgSessions)) > 0
      then "exec ${pkgs.runtimeShell} -l -c \"${(lib.elemAt (lib.attrValues cfgSessions) 0).command}\""
      else "echo 'No sessions configured.' && exit 1"
    }
    fi
    choice=$(${pkgs.gum}/bin/gum choose --header "Select a GUI session" "Shell" ${sessionOptions})
    if [ "$choice" = "Shell" ]; then
      exec ${pkgs.runtimeShell} -l
    fi

    ${sessionCases}

    exit 1
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
    sessions = lib.mkOption {
      type = with lib.types;
        attrsOf (submodule {
          options = {
            name = lib.mkOption {
              type = str;
              description = "Display name for the session";
            };
            command = lib.mkOption {
              type = str;
              description = "Command to execute the session";
            };
          };
        });
      default = {};
      description = "Declarative list of available desktop sessions for the TTY launcher.";
    };
  };

  config = mkMerge [
    (mkIf (cfgXorg.enable || cfgWayland.enable) {
      environment.systemPackages = [pkgs.gum];
    })

    (mkIf cfgWayland.enable {
      xdg.portal = {
        enable = true;
        # wlr.enable = true;
        # extraPortals = with pkgs; [
        #   xdg-desktop-portal-wlr
        # ];

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
        ];

        config = {
          common = {
            default = [
              "gnome"
            ];
          };
        };
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";
      programs.sway.wrapperFeatures.gtk = true;

      environment = {
        pathsToLink = ["/libexec"];
      };

      modules.desktop.sessions.niri = {
        name = "Niri (Wayland)";
        command = "exec ${niriSession}/bin/custom-niri-session";
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

      modules.desktop.sessions.i3 = {
        name = "i3 (Xorg)";
        command = "exec startx";
      };

      environment = {
        pathsToLink = ["/libexec"];
      };
    })

    (mkIf (cfgXorg.enable || cfgWayland.enable) {
      environment.loginShellInit = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec ${guiSelector}/bin/gui-select
        fi
      '';
    })
  ];
}
