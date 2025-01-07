{ config, lib, pkgs, mylib, ... }: {
  options.modules.desktop.colorscheme = {
    enable = lib.mkEnableOption "Colorscheme";

    theme = lib.mkOption {
      type = lib.types.enum ["gruvbox" "kanagawa" "min" "solarized" "vesper" "catppuccin"];
      default = "vesper";
      description = "Colorscheme theme.";
    };

    enableAlacrittyIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableDunstIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableCavaIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableNeovimIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable Neovim integration. It will add a nix_colorscheme.lua
        file to the nvim lua directory with the colorscheme name only.
      '';
    };

    enableZellijIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableGTKIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableI3Integration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    }; };

  config = lib.mkMerge [
    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableNeovimIntegration) {
      xdg.configFile."nvim/lua/nix_colorscheme.lua".text = ''
        return "${(import ./integrations/neovim.nix { inherit mylib; name = config.modules.desktop.colorscheme.theme; })}"
      '';
    })

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableGTKIntegration) {
      gtk = (import ./integrations/gtk.nix { inherit mylib pkgs; name = config.modules.desktop.colorscheme.theme; });
    })
  ];
}
