{
  pkgs,
  mylib,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.displayManager;

  sessionOptions = lib.concatStringsSep " " (map (s: ''"${s.name}"'') (lib.attrValues cfg.sessions));

  sessionCases = lib.concatStringsSep "\n" (map (s:
    mylib.file.substitute ./conf/session-case.sh {
      "@name@" = s.name;
      "@command@" = s.command;
      "@shell@" = pkgs.runtimeShell;
    }) (lib.attrValues cfg.sessions));

  fallback =
    if (lib.length (lib.attrValues cfg.sessions)) > 0
    then "exec ${pkgs.runtimeShell} -l -c \"${(lib.elemAt (lib.attrValues cfg.sessions) 0).command}\""
    else "echo 'No sessions configured.' && exit 1";

  guiSelector = pkgs.writeShellScriptBin "gui-select" (mylib.file.substitute ./conf/gui-select.sh {
    "@sessionOptions@" = sessionOptions;
    "@gum@" = "${pkgs.gum}/bin/gum";
    "@shell@" = pkgs.runtimeShell;
    "@fallback@" = fallback;
    "@cases@" = sessionCases;
  });
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
