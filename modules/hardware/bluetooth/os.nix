{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hardware.bluetooth.system;
in {
  options.modules.hardware.bluetooth.system.enable = mkEnableOption "Bluetooth support";

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    environment.systemPackages = with pkgs; [blueberry];
  };
}
