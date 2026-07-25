{
  lib,
  config,
  myvars,
  ...
}: let
  cfg = config.modules.programs.espanso.system;
in {
  options.modules.programs.espanso.system.enable = lib.mkEnableOption "espanso Wayland input access";

  config = lib.mkIf cfg.enable {
    users.users.${myvars.username}.extraGroups = ["input"];
  };
}
