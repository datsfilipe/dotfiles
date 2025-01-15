{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: {
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
    };
    enableGhosttyIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = let
    colorscheme = import ./themes/${config.modules.desktop.colorscheme.theme}.nix;
  in
    lib.mkMerge [
      (lib.mkIf (config.modules.desktop.colorscheme.enable) (lib.mkMerge [
        (lib.mkIf config.modules.desktop.colorscheme.enableNeovimIntegration {
          programs.datsnvim.settings.theme = import ./integrations/neovim.nix {
            inherit mylib pkgs;
            name = config.modules.desktop.colorscheme.theme;
          };
        })

        (lib.mkIf config.modules.desktop.colorscheme.enableGTKIntegration {
          gtk = import ./integrations/gtk.nix {
            inherit mylib pkgs;
            name = config.modules.desktop.colorscheme.theme;
          };
        })

        (
          lib.mkIf config.modules.desktop.colorscheme.enableI3LockIntegration
          (import ./integrations/i3lock.nix {
            inherit pkgs;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableI3Integration
          (import ./integrations/i3.nix {
            inherit lib pkgs;
            colorscheme = colorscheme;
            enableI3StatusIntegration = config.modules.desktop.colorscheme.enableI3StatusIntegration;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableDunstIntegration
          (import ./integrations/dunst.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableAlacrittyIntegration
          (import ./integrations/alacritty.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableFishIntegration
          (import ./integrations/fish.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableCavaIntegration
          (import ./integrations/cava.nix {
            inherit config lib mylib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableZellijIntegration
          (import ./integrations/zellij.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableGhosttyIntegration
          (import ./integrations/ghostty.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )
      ]))
    ];
}
