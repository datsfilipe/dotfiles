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

    enableI3StatusIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableI3LockIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable i3lock integration. It will add a script called i3lock-theme
        to the user ".local/bin" folder, which should be used instead of i3lock.
      '';
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

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableI3LockIntegration)
      (import ./integrations/i3lock.nix { inherit pkgs; colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableI3Integration)
      (import ./integrations/i3.nix {
        inherit lib pkgs;
        colorscheme = (
          import ./themes/${config.modules.desktop.colorscheme.theme}.nix
        );
        enableI3StatusIntegration = config.modules.desktop.colorscheme.enableI3StatusIntegration;
      })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableDunstIntegration)
      (import ./integrations/dunst.nix { colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableAlacrittyIntegration)
      (import ./integrations/alacritty.nix { colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableFishIntegration)
      (import ./integrations/fish.nix { inherit config lib; colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableCavaIntegration)
      (import ./integrations/cava.nix { inherit config lib mylib; colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )

    (lib.mkIf (config.modules.desktop.colorscheme.enable && config.modules.desktop.colorscheme.enableZellijIntegration)
      (import ./integrations/zellij.nix { inherit config lib; colorscheme = (
        import ./themes/${config.modules.desktop.colorscheme.theme}.nix
      ); })
    )
  ];
}
