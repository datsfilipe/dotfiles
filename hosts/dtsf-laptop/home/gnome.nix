{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "keyboard-toggle@SAH046.github.io"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = false;
      autohide-in-fullscreen = true;
      require-pressure-to-show = false;
      show-apps-at-top = true;
      click-action = "minimize";
      scroll-action = "cycle-windows";
      custom-theme-shrink = true;
      apply-custom-theme = true;
      transparency-mode = "FIXED";
      background-opacity = 1.0;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      show-battery-percentage = true;
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "hibernate";
      sleep-inactive-ac-timeout = 300;
      sleep-inactive-battery-type = "hibernate";
      sleep-inactive-battery-timeout = 300;
    };
  };
}
