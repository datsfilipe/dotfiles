{ pkgs, lib, ... }:
{
  imports = [ ./packages.nix ];

  modules.desktop.colorscheme.theme = "vesper";

  modules.desktop = {
    i3 = let
      mod = "Mod4";
      alt = "Mod1";
      keymaps = import ./keymaps.nix { inherit mod alt pkgs lib; };
      command = str: always: {
        command = str;
        always = always;
        notification = false;
      };
    in {
      settings =  {
        modifier = mod;
        focus.followMouse = false;
        keybindings = keymaps.allBindings;
        
        startup = [
          (command "feh --bg-fill $SYSTEM_WALLPAPER" true)
          (command "dex --autostart --environment i3" true)
          (command "xss-lock --transfer-sleep-lock -- i3lock-theme" true)
          (command "autorandr --load desktop" true)
          (command "udiskie --tray --notify" false)
          (command "i3-msg 'workspace 1'" false)
          (command "dunst -config $HOME/.config/dunstrc" false)
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
        
        window.titlebar = true;
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          style = "Regular";
          size = 8.0;
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
