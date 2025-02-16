{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.modules.desktop.bluetooth = {
    enable = mkEnableOption "Bluetooth support";
  };

  config = mkIf config.modules.desktop.bluetooth.enable {
    hardware.bluetooth.enable = true;
    environment.systemPackages = with pkgs; [blueberry];
  };
}
