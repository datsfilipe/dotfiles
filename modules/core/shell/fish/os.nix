{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.shell.fish.system;
in {
  options.modules.core.shell.fish.system.enable = mkEnableOption "Fish shell on the system";

  config = mkIf cfg.enable {
    programs.fish.enable = true;
    environment.shells = mkDefault [pkgs.bashInteractive pkgs.fish];
    users.defaultUserShell = mkDefault pkgs.bashInteractive;
  };
}
