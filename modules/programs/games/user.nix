{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.games.user;
in {
  options.modules.programs.games.user.enable = mkEnableOption "User gaming packages (Prism Launcher, etc.)";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
