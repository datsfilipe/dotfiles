{
  lib,
  pkgs,
  myvars,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.user.home;
  homeDir =
    if pkgs.stdenv.isDarwin
    then "/Users/${myvars.username}"
    else "/home/${myvars.username}";
in {
  options.modules.core.user.home.enable = mkEnableOption "Home Manager base settings";

  config = mkIf cfg.enable {
    home = {
      username = myvars.username;
      homeDirectory = homeDir;
      stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
  };
}
