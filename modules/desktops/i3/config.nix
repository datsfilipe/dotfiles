{ pkgs, lib, ... }:

let
  theme = (import ../../colorscheme).theme;
  shimejiScriptPath = ../../../dotfiles/scripts/shimeji.sh;
  installScript = scriptPath: ''
    mkdir -p $out/bin
    cp ${scriptPath} $out/bin/shimeji.sh
    chmod +x $out/bin/shimeji.sh
  '';
  shimejiScript = pkgs.runCommand "install-shimeji-script" {} (installScript shimejiScriptPath);

  i3Autostart = ''
    exec --no-startup-id feh --bg-fill $HOME/.config/wallpaper.png
    exec --no-startup-id dex --autostart --environment i3
    exec --no-startup-id xss-lock --transfer-sleep-lock -- i3lock --nofork
    exec --autostart udiskie --tray --notify
  '';

  i3ThemeConfig = ''
    set $hc-color       ${theme.scheme.colors.fg}
    set $bg-color       ${theme.scheme.colors.bg}
    set $sc-color       ${theme.scheme.colors.fg}
    set $fg-color       ${theme.scheme.colors.fg}

    set $color0         ${theme.scheme.colors.altbg}
    set $color8         ${theme.scheme.colors.black}

    set $color1         ${theme.scheme.colors.red}
    set $color9         ${theme.scheme.colors.red}

    set $color2         ${theme.scheme.colors.blue}
    set $color10        ${theme.scheme.colors.blue}

    set $color3         ${theme.scheme.colors.yellow}
    set $color11        ${theme.scheme.colors.yellow}

    set $color4         ${theme.scheme.colors.cyan}
    set $color12        ${theme.scheme.colors.cyan}

    set $color5         ${theme.scheme.colors.magenta}
    set $color13        ${theme.scheme.colors.magenta}

    set $color6         ${theme.scheme.colors.green}
    set $color14        ${theme.scheme.colors.green}

    set $color7         ${theme.scheme.colors.fg}
    set $color15        ${theme.scheme.colors.fg}

    set $color16        ${theme.scheme.colors.bg}
    set $borderInactive ${theme.scheme.colors.bg}
    set $borderActive   ${theme.scheme.colors.altbg}

    client.focused $borderActive $borderActive $color7 $borderActive
    client.focused_inactive $borderInactive $borderInactive $color7	$borderInactive
    client.unfocused $borderInactive $borderInactive $color7	$borderInactive
    client.urgent $color9 $color9	$color7	$color9
    client.background $bg-color
  '';

  i3Keymaps = ''
    set $mod Mod4
    set $alt Mod1

    floating_modifier $mod

    bindsym $mod+q kill
    bindsym $mod+Return exec alacritty
    bindsym $mod+a exec chromium
    bindsym Print exec exec flameshot gui
    bindsym $alt+k exec $HOME/.local/bin/switch-kb-variant
    bindsym $alt+i exec $HOME/.local/bin/switch-kb-variant intl

    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    bindsym $mod+1 workspace 1
    bindsym $mod+2 workspace 2
    bindsym $mod+3 workspace 3
    bindsym $mod+4 workspace 4
    bindsym $mod+5 workspace 5
    bindsym $mod+6 workspace 6
    bindsym $mod+7 workspace 7
    bindsym $mod+8 workspace 8
    bindsym $mod+9 workspace 9
    bindsym $mod+0 workspace 10

    bindsym $mod+Shift+1 move container to workspace 1
    bindsym $mod+Shift+2 move container to workspace 2
    bindsym $mod+Shift+3 move container to workspace 3
    bindsym $mod+Shift+4 move container to workspace 4
    bindsym $mod+Shift+5 move container to workspace 5
    bindsym $mod+Shift+6 move container to workspace 6
    bindsym $mod+Shift+7 move container to workspace 7
    bindsym $mod+Shift+8 move container to workspace 8
    bindsym $mod+Shift+9 move container to workspace 9
    bindsym $mod+Shift+0 move container to workspace 10

    bindsym $mod+comma focus parent
    bindsym $mod+period focus child

    bindsym $mod+p exec rofi -show
    bindsym $mod+o exec powermenu
    bindsym $mod+n exec $HOME/.local/bin/datsvault -n
    bindsym $alt+s exec ${shimejiScript}/.local/bin/shimeji.sh

    bindsym $alt+h split h
    bindsym $alt+l split v
    bindsym $mod+f fullscreen toggle

    bindsym $mod+space floating toggle
    bindsym $mod+s layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split
    bindsym $mod+r mode "resize"

    bindsym $mod+Shift+c reload
    bindsym $mod+Shift+r exec i3-msg restart
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
  '';

  i3Bar = ''
    bar {
      status_command i3status
      position bottom
      workspace_buttons yes
      font pango: DMSans Medium, JetBrainsMono Nerd Font 8

      colors {
        background $bg-color
        statusline $color7
        separator $color7

        active_workspace $color7 $borderActive $fg-color
        focused_workspace $color7 $borderActive $fg-color
      }
    }
  '';
in {
  xdg.configFile."i3/config".text = ''
    ${i3Autostart}
    ${lib.fileContents ../../../dotfiles/i3/config}
    ${i3Keymaps}
    ${i3ThemeConfig}
    ${i3Bar}
  '';

  xdg.configFile."i3status/config".text = ''
    ${lib.fileContents ../../../dotfiles/i3/i3status/config}
  '';

  home.file.".xinitrc".text = ''
    ${lib.fileContents ../../../dotfiles/.xinitrc}
  '';
}
