{ pkgs, lib, ... }:

let
  hyprlandAutostart = ''
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=dunst
    exec-once=ags
    exec-once=${pkgs.swaybg}/bin/swaybg -m fill -i $HOME/.config/wallpaper.png
  '';

  hyprlandKeymaps = ''
    $mainMod=SUPER

    bind=$mainMod,Return,exec,alacritty
    bind=$mainMod,A,exec,firefox
    bind=,print,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/media/photos/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/media/photos/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"
    bind=$mainMod,Q,killactive
    bind=$mainMod,Space,togglefloating
    bind=SUPER_SHIFT,Space,togglesplit
    bind=$mainMod,P,exec,ags --toggle-window launcher
    bind=$mainMod,O,exec,ags --toggle-window powermenu
    bind=$mainMod,N,exec,$HOME/.local/bin/datsvault -n
    bind=$mainMod,K,exec,$HOME/.local/bin/switch-kb-variant
    bind=$mainMod,I,exec,$HOME/.local/bin/switch-kb-variant intl

    bind=$mainMod,h,movefocus,l
    bind=$mainMod,l,movefocus,r
    bind=$mainMod,k,movefocus,u
    bind=$mainMod,j,movefocus,d

    bind=SUPER_SHIFT,h,movewindow,l
    bind=SUPER_SHIFT,l,movewindow,r
    bind=SUPER_SHIFT,k,movewindow,u
    bind=SUPER_SHIFT,j,movewindow,d

    bind=$mainMod,1,workspace,1
    bind=$mainMod,2,workspace,2
    bind=$mainMod,3,workspace,3
    bind=$mainMod,4,workspace,4
    bind=$mainMod,5,workspace,5
    bind=$mainMod,6,workspace,6
    bind=$mainMod,7,workspace,7
    bind=$mainMod,8,workspace,8
    bind=$mainMod,9,workspace,9
    bind=$mainMod,0,workspace,10

    # Move window, doesnt switch to the workspace
    bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
    bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
    bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
    bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
    bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
    bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
    bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
    bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
    bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
    bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

    # Move window, switch to the workspace
    bind = $mainMod CTRL, 1, movetoworkspace, 1
    bind = $mainMod CTRL, 2, movetoworkspace, 2
    bind = $mainMod CTRL, 3, movetoworkspace, 3
    bind = $mainMod CTRL, 4, movetoworkspace, 4
    bind = $mainMod CTRL, 5, movetoworkspace, 5
    bind = $mainMod CTRL, 6, movetoworkspace, 6
    bind = $mainMod CTRL, 7, movetoworkspace, 7
    bind = $mainMod CTRL, 8, movetoworkspace, 8
    bind = $mainMod CTRL, 9, movetoworkspace, 9
    bind = $mainMod CTRL, 0, movetoworkspace, 10

    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';
in {
  xdg.configFile."hypr/hyprland.conf".text = ''
    ${lib.fileContents ../../../dotfiles/hyprland.conf}
    ${hyprlandKeymaps}
    ${hyprlandAutostart}
  '';
}
