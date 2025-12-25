{
  config,
  mypkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.programs.devtools.user;
in {
  options.modules.programs.devtools.user.enable = mkEnableOption "Developer GUI tools";

  config = mkIf cfg.enable {
    modules.desktop.nupkgs.packages = with mypkgs; [
      tableplus
    ];
  };
}
