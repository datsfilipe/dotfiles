{
  pkgs,
  lib,
  nur-ryan4yin ? null,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.btop.user;
in {
  options.modules.programs.btop.user.enable = mkEnableOption "btop";

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
