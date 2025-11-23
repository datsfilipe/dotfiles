{ lib, mylib, ... }:
{
  imports = (mylib.file.scanPaths ../../../modules "user.nix") ++ [./packages.nix];

  modules.core.shell.fish.user.enable = true;
  modules.core.shell.ssh.user.enable = true;
  modules.core.user.home.enable = true;

  modules.desktop.wms.niri.user.enable = true;
  modules.desktop.wms.sway.user.enable = false;
  modules.desktop.wms.i3.user.enable = false;
  modules.desktop.wms.common.enable = true;

  modules.hardware.monitors = {
    enable = true;
    enableNvidiaSupport = false;
    monitors = [
      {
        name = "eDP-1";
        resolution = "1920x1080";
        refreshRate = "59.997";
        scale = "1.3";
        nvidiaSettings = {
          coordinate = {
            x = 0;
            y = 0;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
    ];
  };

  modules.desktop.wallpaper.enable = true;

  modules.desktop.conf = {
    enableDunstIntegration = true;
    enableCavaIntegration = true;
    enableZellijIntegration = true;
  };

  modules.desktop.nupkgs.enable = true;
  modules.programs.tools.user.enable = true;
  modules.programs.media.user.enable = true;
  modules.programs.devtools.user.enable = true;
  modules.programs.desktopapps.user.enable = true;
  modules.programs.btop.user.enable = true;
  modules.programs.browsers.user.enable = true;
  modules.desktop.addons.gtk.user.enable = true;
  modules.desktop.addons.xdg.user.enable = true;

  modules.programs.git.enable = true;
  modules.programs.terminal.default = "ghostty";

  modules.editors.neovim.user.enable = true;

  modules.desktop.colorscheme = {
    enable = true;
    enableDunstIntegration = true;
    enableNeovimIntegration = true;
    enableGTKIntegration = true;
    enableFishIntegration = true;
    enableCavaIntegration = true;
    enableZellijIntegration = true;
    enableGhosttyIntegration = true;
    enableFzfIntegration = true;
    enableNiriIntegration = true;
    enableFuzzelIntegration = true;
  };

  modules.themes.catppuccin.enable = false;
  modules.themes.vesper.enable = false;
  modules.themes.gruvbox.enable = true;
}
