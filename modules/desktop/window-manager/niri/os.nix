{
  pkgs,
  mypkgs,
  myvars,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wm.niri.system;

  niriSession = pkgs.writeShellScriptBin "custom-niri-session" (builtins.readFile ./conf/custom-niri-session.sh);

  greeterConfig = pkgs.writeText "niri-greeter.kdl" ''
    environment {
        DATS_GREET_USER "${myvars.username}"
        DATS_GREET_SESSION "${niriSession}/bin/custom-niri-session"
    }
    input {
        keyboard {
            xkb {
                layout "us"
                variant "altgr-intl"
            }
        }
        touchpad {
            tap
        }
    }
    hotkey-overlay {
        skip-at-startup
    }
    cursor {
        xcursor-theme "Quintom_Snow"
        xcursor-size 24
        hide-when-typing
    }
    layout {
        focus-ring {
            off
        }
        border {
            off
        }
    }
    animations {
        off
    }
    spawn-at-startup "${mypkgs.quickshell}/bin/wgreet"
    binds {
        Ctrl+Alt+Delete {
            quit skip-confirmation=true
        }
    }
  '';
  greeterCommand = pkgs.writeShellScript "niri-greeter" ''
    export XCURSOR_PATH=${pkgs.quintom-cursor-theme}/share/icons
    export XCURSOR_THEME=Quintom_Snow
    export XCURSOR_SIZE=24
    exec ${pkgs.systemd}/bin/systemd-cat -t niri-greeter ${pkgs.niri}/bin/niri -c ${greeterConfig}
  '';
in {
  options.modules.desktop.wm.niri.system = {
    enable = mkEnableOption "Niri (Wayland) system support";
    greeter.enable = mkEnableOption "Quickshell login screen on greetd";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        config = {
          common = {
            "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
            default = ["gnome"];
          };
        };
      };

      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      security.pam.services.dats-lock = {
        allowNullPassword = false;
        unixAuth = true;
        startSession = false;
      };

      programs.sway.wrapperFeatures.gtk = true;
      environment.pathsToLink = ["/libexec"];

      modules.desktop.displayManager.enable = mkDefault (!cfg.greeter.enable);
      modules.desktop.displayManager.sessions.niri = {
        name = "Niri (Wayland)";
        command = "exec ${niriSession}/bin/custom-niri-session";
      };
    }

    (mkIf cfg.greeter.enable {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${greeterCommand}";
          user = "greeter";
        };
      };

      users.users.greeter = {
        home = "/var/lib/greeter";
        createHome = true;
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/greeter 0700 greeter greeter - -"
      ];

      security.pam.services.greetd.enableGnomeKeyring = true;
    })
  ]);
}
