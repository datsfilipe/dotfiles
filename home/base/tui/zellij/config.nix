{ config, lib, mylib, pkgs, ... }: {
  options.modules.desktop.zellij.config = {
    enable = lib.mkEnableOption "Zellij configuration.";

    content = lib.mkOption {
      type = lib.types.lines;
      default = "default";
      description = "Zellij kdl configuration content.";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Zellij theme.";
    };

    themeConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Zellij theme configuration.";
    };
    
    layoutContent = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Zellij layout content.";
    };
  };

  config = lib.mkIf config.modules.desktop.zellij.config.enable {
    xdg.configFile."zellij/config.kdl".text = ''
      ${config.modules.desktop.zellij.config.content}

      ${lib.optionalString (config.modules.desktop.zellij.config.theme != "") ''
        theme "${config.modules.desktop.zellij.config.theme}"
      ''}

      ${lib.optionalString (config.modules.desktop.zellij.config.theme != "") ''
        themes {
          ${config.modules.desktop.zellij.config.theme} {
            ${lib.replaceStrings ["="] [" "] (
              mylib.formatSections [] config.modules.desktop.zellij.config.themeConfig
            )}
          }
        }
      ''}
    '';

    xdg.configFile."zellij/layouts/default.kdl".text = config.modules.desktop.zellij.config.layoutContent;
  };
}
