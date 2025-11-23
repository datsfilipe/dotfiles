{
  config,
  mylib,
  lib,
  ...
}:
with lib; {
  configOptions.modules.desktop.conf = {
    enablePicomIntegration = mkEnableOption "Enable picom integration";

    picom.settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Settings for picom";
    };
  };

  configContent = mkIf config.modules.desktop.conf.enablePicomIntegration {
    xdg.configFile."picom/picom.conf".text =
      mylib.format.sections [] config.modules.desktop.conf.picom.settings;
  };
}
