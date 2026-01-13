{
  lib,
  mylib,
  myvars,
  ...
}: let
in {
  imports = (mylib.file.scanPaths ../../../modules "user.nix") ++ [./packages.nix];

  modules.hardware.machine.hostname = "dtsf-laptop";

  modules.core.shell.fish.user.enable = true;
  modules.core.user.home.enable = true;

  modules.hardware.monitors = {
    enable = true;
    monitors = myvars.hostsConfig.monitors.laptop;
  };

  modules.desktop.conf.enableZellijIntegration = true;

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
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
      background-opacity = 0.8;
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
  };

  modules.desktop.nupkgs.enable = true;
  modules.programs.tools.user.enable = true;
  modules.programs.media.user.enable = true;
  modules.programs.devtools.user.enable = true;
  modules.programs.desktopapps.user.enable = true;
  modules.programs.bottom.user.enable = true;
  modules.programs.browsers.user.enable = true;

  modules.desktop.addons.gtk.user.enable = true;
  modules.desktop.addons.xdg.user.enable = true;

  modules.programs.git.enable = true;
  modules.programs.terminal.default = "alacritty";

  modules.editors.neovim.user.enable = true;

  modules.desktop.colorscheme = {
    enable = true;
    enableNeovimIntegration = true;
    enableGTKIntegration = true;
    enableFishIntegration = true;
    enableAlacrittyIntegration = true;
    enableFzfIntegration = true;
  };

  modules.themes.${myvars.hostsConfig.theme}.enable = true;
}
