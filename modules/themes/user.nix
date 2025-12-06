{
  config,
  lib,
  pkgs,
  mylib,
  ...
}: {
  options.modules.themes = let
    themeNames = ["catppuccin" "kanagawa" "min" "solarized" "vesper" "gruvbox"];
  in
    builtins.listToAttrs (map (name: {
        inherit name;
        value.enable = lib.mkEnableOption "${name} theme (sets modules.desktop.colorscheme.theme)";
      })
      themeNames);

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
    enableAstalIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
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
    enableSwayIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableGhosttyIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableWeztermIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableRioIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableFzfIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableNiriIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    enableFuzzelIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = let
    colorscheme =
      import
      ./${
        config.modules.desktop.colorscheme.theme
      }.nix;
  in
    lib.mkMerge [
      (lib.mkMerge (
        map (name:
          lib.mkIf (config.modules.themes.${name}.enable or false) {
            modules.desktop.colorscheme = {
              enable = true;
              theme = name;
            };
          })
        ["catppuccin" "kanagawa" "min" "solarized" "vesper" "gruvbox"]
      ))
      (lib.mkIf (config.modules.desktop.colorscheme.enable) (lib.mkMerge [
        (lib.mkIf config.modules.desktop.colorscheme.enableNeovimIntegration {
          programs.datsnvim.settings.theme = import ./integration/neovim.nix {
            inherit mylib pkgs;
            name = config.modules.desktop.colorscheme.theme;
          };
        })

        (
          lib.mkIf config.modules.desktop.colorscheme.enableAstalIntegration
          (import ./integration/astal.nix {
            colorscheme = colorscheme;
          })
        )

        (lib.mkIf config.modules.desktop.colorscheme.enableGTKIntegration {
          gtk = import ./integration/gtk.nix {
            inherit mylib pkgs;
            name = config.modules.desktop.colorscheme.theme;
          };
        })

        (
          lib.mkIf config.modules.desktop.colorscheme.enableI3LockIntegration
          (import ./integration/i3lock.nix {
            inherit pkgs;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableI3Integration
          (import ./integration/i3.nix {
            inherit lib pkgs config;
            colorscheme = colorscheme;
            enableI3StatusIntegration = config.modules.desktop.colorscheme.enableI3StatusIntegration;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableSwayIntegration
          (import ./integration/sway.nix {
            inherit lib pkgs;
            colorscheme = colorscheme;
            enableI3StatusIntegration = config.modules.desktop.colorscheme.enableI3StatusIntegration;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableDunstIntegration
          (import ./integration/dunst.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableAlacrittyIntegration
          (import ./integration/alacritty.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableFishIntegration
          (import ./integration/fish.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableCavaIntegration
          (import ./integration/cava.nix {
            inherit config lib mylib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableZellijIntegration
          (import ./integration/zellij.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableGhosttyIntegration
          (import ./integration/ghostty.nix {
            inherit config lib;
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableWeztermIntegration
          (import ./integration/wezterm.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableRioIntegration
          (import ./integration/rio.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableFzfIntegration
          (import ./integration/fzf.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableNiriIntegration
          (import ./integration/niri.nix {
            colorscheme = colorscheme;
          })
        )

        (
          lib.mkIf config.modules.desktop.colorscheme.enableFuzzelIntegration
          (import ./integration/fuzzel.nix {
            inherit mylib;
            colorscheme = colorscheme;
          })
        )
      ]))
    ];
}
