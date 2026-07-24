{
  pkgs,
  lib,
  config,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.hardware.ddc.system;
in {
  options.modules.hardware.ddc.system.enable = mkEnableOption "External monitor brightness via DDC/CI (ddcutil)";

  config = mkIf cfg.enable {
    hardware.i2c.enable = true;
    environment.systemPackages = with pkgs; [ddcutil];
    users.users.${myvars.username}.extraGroups = ["i2c"];

    boot.extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    boot.kernelModules = ["i2c-dev" "ddcci_backlight"];
  };
}
