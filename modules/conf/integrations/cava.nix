{ config, lib, mylib, ... }: with lib; {
  configOptions.modules.desktop.conf = {
    enableCavaIntegration = mkEnableOption "Enable cava integration";

    cava.settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Settings for cava";
    };
  };

  configContent = mkIf config.modules.desktop.conf.enableCavaIntegration {
    xdg.configFile."cava/config".text = ''
      ${mylib.format.sections ["color"] config.modules.desktop.conf.cava.settings}
    '';
  };
}
