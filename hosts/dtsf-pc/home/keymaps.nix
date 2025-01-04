{ mod, alt, pkgs, lib, ... }: let 
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
    "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
    "${mod}+a" = "exec ${pkgs.chromium}/bin/chromium --force-dark-mode --enable-features=WebUIDarkMode";
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
in  {
  allBindings = staticBindings // workspaceBindings;
}
