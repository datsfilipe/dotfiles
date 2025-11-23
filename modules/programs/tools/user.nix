{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.tools.user;
in {
  options.modules.programs.tools.user.enable = mkEnableOption "Developer tools (direnv)";

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
    };
  };
}
