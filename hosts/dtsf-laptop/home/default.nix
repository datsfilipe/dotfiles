{
  lib,
  mylib,
  ...
}: let
  common = import ../../common;
in {
  imports = (mylib.file.scanPaths ../../../modules "user.nix") ++ [./packages.nix];

  modules.core.shell.fish.user.enable = true;
  modules.core.user.home.enable = true;

  modules.desktop.wms.niri.user.enable = true;
  modules.desktop.wms.common.enable = true;

  modules.hardware.monitors = {
    enable = true;
    monitors = common.monitors.laptop;
  };

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
  modules.programs.bottom.user.enable = true;
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

  modules.themes.${common.theme}.enable = true;
}
