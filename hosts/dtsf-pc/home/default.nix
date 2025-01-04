{ pkgs, lib, ... }:
{
  imports = [ ./packages.nix ];

  modules.desktop = {
    i3 = let
      mod = "Mod4";
      alt = "Mod1";
      keymaps = import ./keymaps.nix { inherit mod alt pkgs lib; };
      command = str: {
        command = str;
        always = true;
        notification = false;
      };
    in {
      settings =  {
        modifier = mod;
        focus.followMouse = false;
        keybindings = keymaps.allBindings;
        
        startup = [
          (command "feh --bg-fill $SYSTEM_WALLPAPER")
          (command "dex --autostart --environment i3")
          (command "udiskie --tray --notify")
          (command "autorandr --load desktop")
          (command "i3-msg 'workspace 1'")
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
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
    '';
  };
}
