{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.displayManager;

  sessionOptions = lib.concatStringsSep " " (map (s: ''"${s.name}"'') (lib.attrValues cfg.sessions));

  sessionCases = lib.concatStringsSep "\n" (map (s: ''
    if [ "$choice" = "${s.name}" ]; then
      cmd='${s.command}'
      case "$cmd" in
        exec\ *) eval "$cmd" ;;
        *) exec ${pkgs.runtimeShell} -l -c "$cmd" ;;
      esac
    fi
  '') (lib.attrValues cfg.sessions));

  guiSelector = pkgs.writeShellScriptBin "gui-select" ''
    set -eu
    IFS=$'\n\t'
    options=(${sessionOptions})
    if ! command -v ${pkgs.gum}/bin/gum >/dev/null 2>&1; then
      echo "gum not installed. Falling back to first session."
      ${
      if (lib.length (lib.attrValues cfg.sessions)) > 0
      then "exec ${pkgs.runtimeShell} -l -c \"${(lib.elemAt (lib.attrValues cfg.sessions) 0).command}\""
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
  options.modules.desktop.displayManager = {
    enable = mkEnableOption "Terminal login GUI chooser";
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

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.gum];

    environment.loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec ${guiSelector}/bin/gui-select
      fi
    '';
  };
}
