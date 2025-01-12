{ mod, alt, pkgs, lib, ... }: let 
  mod = "Mod4";
  alt = "Mod1";
  print = "Print";
  workspaceBindings = builtins.listToAttrs (
    (map (i: {
      name = "${mod}+${toString i}";
      value = "workspace ${toString i}";
    }) (lib.range 1 9)) ++
    (map (i: {
      name = "${mod}+Shift+${toString i}";
      value = "move container to workspace ${toString i}";
    }) (lib.range 1 9)) ++
    [
      { name = "${mod}+0"; value = "workspace 10"; }
      { name = "${mod}+Shift+0"; value = "move container to workspace 10"; }
    ]
  );
  staticBindings = {
    "${mod}+q" = "kill";
    "${mod}+t" = "exec ${pkgs.alacritty}/bin/alacritty";
    "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty -e ${pkgs.zellij}/bin/zellij attach dtsf -c";
    "${mod}+a" = "exec chromium --wv --force-dark-mode --enable-features=WebUIDarkMode";
    "${mod}+d" = "exec $HOME/.local/bin/dmenu-theme";
    "${mod}+Shift+m" = "exec shimeji";

    "${alt}+k" = "exec $HOME/.local/bin/switch-kb-variant";
    "${alt}+i" = "exec $HOME/.local/bin/switch-kb-variant intl";

    "${print}" = "exec flameshot gui";

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
    "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'leave i3' -B 'exit i3' 'exec i3-msg exit; pkill -15 Xorg'\"";
    "${mod}+Shift+o" = "exec \"i3-nagbar -t error -m 'turn off the computer' -B 'turn off' 'systemctl poweroff'\"";

    "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
    "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";
  };
in  {
  allBindings = staticBindings // workspaceBindings;
}
