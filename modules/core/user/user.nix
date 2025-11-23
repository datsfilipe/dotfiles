{
  lib,
  myvars,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.user.home;
in {
  options.modules.core.user.home.enable = mkEnableOption "Home Manager base settings";

  config = mkIf cfg.enable {
    home = {
      username = myvars.username;
      homeDirectory = "/home/${myvars.username}";
      stateVersion = "25.05";
    };

    programs.home-manager.enable = true;
  };
}
