{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.games.system;
in {
  options.modules.programs.games.system.enable = mkEnableOption "Gaming stack";

  config = mkIf cfg.enable {
    programs.steam.enable = true;
  };
}
