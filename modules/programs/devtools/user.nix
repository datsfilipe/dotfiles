{
  pkgs-unstable,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.devtools.user;
in {
  options.modules.programs.devtools.user.enable = mkEnableOption "Developer GUI tools";

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      beekeeper-studio
    ];
  };
}
