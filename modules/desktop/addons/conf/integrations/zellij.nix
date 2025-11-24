{
  config,
  lib,
  mylib,
  pkgs,
  ...
}: {
  configOptions.modules.desktop.conf = {
    enableZellijIntegration = lib.mkEnableOption "Zellij configuration.";

    zellij.content = lib.mkOption {
      type = lib.types.lines;
      default = "default";
      description = "Zellij kdl configuration content.";
    };

    zellij.theme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Zellij theme.";
    };

    zellij.themeConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Zellij theme configuration.";
    };

    zellij.layoutContent = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Zellij layout content.";
    };
  };

  configContent = lib.mkIf config.modules.desktop.conf.enableZellijIntegration {
    xdg.configFile."zellij/config.kdl".text = ''
        ${config.modules.desktop.conf.zellij.content}

      ${lib.optionalString (config.modules.desktop.conf.zellij.theme != "") ''
        theme "${config.modules.desktop.conf.zellij.theme}"
      ''}

      ${lib.optionalString (config.modules.desktop.conf.zellij.theme != "") ''
        themes {
          ${config.modules.desktop.conf.zellij.theme} {
            ${lib.replaceStrings ["="] [" "] (
          mylib.format.sections [] config.modules.desktop.conf.zellij.themeConfig
        )}
          }
        }
      ''}
    '';

    xdg.configFile."zellij/layouts/default.kdl".text = config.modules.desktop.conf.zellij.layoutContent;
  };
}
