{
  lib,
  mylib,
  ...
}: let
  hostName = "dtsf-laptop";
  common = import ../common;
in {
  imports =
    [./hardware-configuration.nix ./boot.nix]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  services.libinput.enable = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  modules.core.boot.system.enable = true;
  modules.core.nix.system.enable = true;
  modules.core.security.system.enable = true;
  modules.core.user.system.enable = true;
  modules.core.system.enable = true;
  modules.core.shell.fish.system.enable = true;
  modules.core.shell.ssh.system.enable = true;
  modules.core.misc.ssh-manager.enable = true;

  modules.hardware.audio.system.enable = true;
  modules.hardware.bluetooth.system.enable = true;
  modules.hardware.monitors = {
    enable = true;
    monitors = common.monitors.laptop;
  };

  modules.desktop.displayManager.enable = true;
  modules.desktop.wms.niri.system.enable = true;

  modules.desktop.wallpaper = {
    enable = true;
    file = common.wallpaper;
  };

  modules.editors.neovim.system.enable = true;
  modules.desktop.fonts.system.enable = true;

  modules.programs.virtualization.system.enable = true;
  modules.programs.fhs.system.enable = true;

  system.stateVersion = "25.11";
}
