{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.displayManager;

  sessionList = lib.attrValues cfg.sessions;

  launch =
    if sessionList == []
    then "echo 'No sessions configured.'"
    else let
      cmd = (lib.head sessionList).command;
    in
      if lib.hasPrefix "exec " cmd
      then cmd
      else "exec ${pkgs.runtimeShell} -l -c \"${cmd}\"";
in {
  options.modules.desktop.displayManager = {
    enable = mkEnableOption "Auto-launch GUI session on tty1";
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
    environment.loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${launch}
      fi
    '';
  };
}
