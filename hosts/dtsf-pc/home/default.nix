{
  pkgs,
  lib,
  ...
}: {
  imports = [./packages.nix];

  modules.desktop.colorscheme.theme = "gruvbox";

  modules.desktop = {
    sway = let
      mod = "Mod4";
      alt = "Mod1";
      keymaps = import ./keymaps.nix {inherit mod alt pkgs lib;};
      command = str: always: {
        command = str;
        always = always;
      };
    in {
      settings = {
        modifier = mod;
        focus.followMouse = false;
        keybindings = keymaps.allBindings;

        startup = [
          (command "udiskie --notify" true)
          (command "swaymsg 'workspace 1'" false)
          (command "dunst -config $HOME/.config/dunstrc" true)
          (command "systemctl --user restart wallpaper.service" true)
        ];

        modes = {
          resize = {
            h = "resize shrink width 10 px or 10 ppt";
            j = "resize grow height 10 px or 10 ppt";
            k = "resize shrink height 10 px or 10 ppt";
            l = "resize grow width 10 px or 10 ppt";

            Left = "resize shrink width 10 px or 10 ppt";
            Down = "resize grow height 10 px or 10 ppt";
            Up = "resize shrink height 10 px or 10 ppt";
            Right = "resize grow width 10 px or 10 ppt";

            Return = "mode default";
            Escape = "mode default";
            "${mod}+r" = "mode default";
          };
        };

        fonts = {
          names = ["JetBrainsMono Nerd Font"];
          style = "Regular";
          size = 8.0;
        };

        window.titlebar = true;
        window.commands = [
          {
            command = "floating enable, sticky enable";
            criteria = {title = "^win";};
          }
        ];

        input = {
          "1133:16500:Logitech_G305" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host github.com
      IdentityFile ~/.ssh/main_key
      IdentitiesOnly yes
      AddKeysToAgent yes
    '';
  };
}
