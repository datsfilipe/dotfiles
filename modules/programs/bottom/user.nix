{
  lib,
  config,
  pkgs,
  ...
}: {
  options.modules.programs.bottom.user.enable = lib.mkEnableOption "bottom";

  config = lib.mkIf config.modules.programs.bottom.user.enable {
    home.packages = [pkgs.bottom];
  };
}
