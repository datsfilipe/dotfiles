{
  config,
  mod,
  alt,
  pkgs,
  lib,
  ...
}: let
  mod = "Mod4";
  alt = "Mod1";
  print = "Print";
  msgCmd =
    if config.modules.desktop.sway.enable
    then "swaymsg"
    else "i3-msg";

  exit = "-B 'leave' 'exec ${msgCmd} exit && exec loginctl terminate-user $USER'";
  turnoff = "-B 'shutdown' 'exec systemctl poweroff'";
  reboot = "-B 'reboot' 'exec systemctl reboot'";

  nag =
    if config.modules.desktop.sway.enable
    then "swaynag"
    else "i3-nagbar";

  workspaceBindings = builtins.listToAttrs (
    (map (i: {
      name = "${mod}+${toString i}";
      value = "workspace ${toString i}";
    }) (lib.range 1 9))
    ++ (map (i: {
      name = "${mod}+Shift+${toString i}";
      value = "move container to workspace ${toString i}";
    }) (lib.range 1 9))
    ++ [
      {
        name = "${mod}+0";
        value = "workspace 10";
      }
      {
        name = "${mod}+Shift+0";
        value = "move container to workspace 10";
      }
    ]
  );
  staticBindings = {
    "${mod}+q" = "kill";
    "${mod}+t" = "exec ${pkgs.alacritty}/bin/alacritty";
    "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty -e ${pkgs.zellij}/bin/zellij attach dtsf -c";
    "${mod}+a" = "exec brave";
    "${mod}+d" = "exec $HOME/.local/bin/launcher";
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
    "${mod}+Shift+e" = "exec \"${nag} -t warning -m 'leave, shutdown or reboot?' ${turnoff} ${reboot} ${exit}\"";

    "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
    "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";
  };
in {
  allBindings = staticBindings // workspaceBindings;
}
