{ pkgs, lib, ... }:
{
  modules.desktop = {
    i3 = let 
      mod = "Mod4";
      alt = "Mod1";
      workspaceBindings = builtins.listToAttrs (map (i: {
        name = "${mod}+${toString i}";
        value = "workspace ${toString i}";
      }) (lib.range 1 9) ++ [
        { name = "${mod}+0"; value = "workspace 10"; }
        { name = "${mod}+Shift+0"; value = "move container to workspace 10"; }
      ]);
      staticBindings = {
        "${mod}+q" = "kill";
        "${mod}+t" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${mod}+a" = "exec ${pkgs.chromium}/bin/chromium";
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "Print" = "exec ${pkgs.flameshot}/bin/flameshot gui";
        "${alt}+k" = "exec $HOME/.local/bin/switch-kb-variant";
        "${alt}+i" = "exec $HOME/.local/bin/switch-kb-variant intl";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+comma" = "focus parent";
        "${mod}+period" = "focus child";

        "${alt}+h" = "split h";
        "${alt}+l" = "split v";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+space" = "floating toggle";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+r" = "mode resize";

        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "exec i3-msg restart";
        "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'\"";

        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";
      };
      allBindings = staticBindings // workspaceBindings;
      command = str: {
        command = str;
        always = true;
        notification = false;
      };
    in {
      settings =  {
        modifier = mod;
        keybindings = allBindings;
        
        startup = [
          (command "feh --bg-fill $SYSTEM_WALLPAPER")
          (command "dex --autostart --environment i3")
          (command "udiskie --tray --notify")
          (command "autorandr --load desktop")
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

  programs.i3status = {
    enable = true;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "%volume";
          format_muted = "X (%volume)";
          device = "pulse:1";
        };
      };
      "disk /" = {
        position = 2;
        settings = {
          format = "/ %avail";
        };
      };
      wireless = {
        position = 3;
        settings = {
          format = "W: (%quality at %essid) %ip";
          format_down = "W: down";
        };
      };
      load = {
        position = 4;
        settings = {
          format = "%1min";
        };
      };
      battery = {
        position = 5;
        settings = {
          format = "%status %percentage";
          format_down = "no batt.";
          status_chr = "+ --";
          status_bat = "-";
          status_unk = "unk";
          status_full = "! --";
          low_threshold = 10;
          threshold_type = "percentage";
          last_full_capacity = false;
          hide_seconds = true;
          path = "/sys/class/power_supply/BAT1/uevent";
        };
      };
      tztime = {
        position = 6;
        settings = {
          format = "%Y-%m-%d %H:%M:%S";
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    # extraConfig = ''
    #   Host github.com
    #       IdentityFile ~/.ssh/pkey
    #       IdentitiesOnly yes
    # '';
  };
}
