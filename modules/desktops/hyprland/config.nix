{ pkgs, ... }:

let
  hyprlandConfig = ''
    monitor=,preferred,auto,1

    input {
      kb_layout=us
      kb_variant=altgr-intl
      kb_options=compose:menu,level3:ralt_switch,grp:win_space_toggle

      follow_mouse=0
      float_switch_override_focus=true

      sensitivity=0.7
    }

    general {
      gaps_in=3
      gaps_out=3
      border_size=1

      col.active_border=rgba(ff7a84ff)
      col.inactive_border=rgba(1a1a1aee)

      layout=dwindle
    }

    decoration {
      rounding=4
      inactive_opacity=0.98

      drop_shadow=yes
      shadow_range=4
      shadow_render_power=3
      col.shadow=rgba(1a1a1aee)
    }

    animations {
      enabled=yes

      bezier=myBezier,0.05,0.9,0.1,1.05
      bezier=overshot,0.13,0.99,0.29,1.1

      animation=windows,1,5,overshot,popin
      animation=border,1,5,default
      animation=fade,1,5,default
      animation=workspaces,1,6,default
    }

    dwindle {
      pseudotile=yes
      preserve_split=yes
      pseudotile=true
      force_split=2
    }

    master {
      new_is_master=true
      new_on_top=true,
    }

    gestures {
      workspace_swipe=on
      workspace_swipe_min_speed_to_force=50
      workspace_swipe_distance=550
    }

    misc {
      disable_hyprland_logo=on
      enable_swallow=true

      animate_manual_resizes=false
    }

    $mainMod=SUPER

    bind=$mainMod,Return,exec,wezterm
    bind=$mainMod,A,exec,google-chrome-stable
    bind=$mainMod,P,exec,anyrun
    bind=$mainMod,O,exec,ags --toggle-window powermenu
    bind=,print,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/media/photos/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/media/photos/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"
    bind=$mainMod,Q,killactive
    bind=$mainMod,Space,togglefloating
    bind=SUPER_SHIFT,Space,togglesplit

    bind=$mainMod,left,movefocus,h
    bind=$mainMod,right,movefocus,l
    bind=$mainMod,up,movefocus,k
    bind=$mainMod,down,movefocus,j

    bind=SUPER_SHIFT,left,movewindow,h
    bind=SUPER_SHIFT,right,movewindow,l
    bind=SUPER_SHIFT,up,movewindow,k
    bind=SUPER_SHIFT,down,movewindow,j

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

    # Auto start
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=dunst
    exec-once=ags
    exec-once=${pkgs.swaybg}/bin/swaybg -m fill -i $HOME/.config/wallpaper.png
  '';
in {
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConfig;
}
