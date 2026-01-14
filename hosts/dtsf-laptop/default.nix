{
  lib,
  pkgs,
  mylib,
  myvars,
  ...
}: let
  hostName = "dtsf-laptop";
in {
  imports =
    [./hardware-configuration.nix ./boot.nix]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  services.libinput.enable = true;

  networking = {
    inherit hostName;
    networkmanager.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  hardware.sensor.iio.enable = true;
  services.udev.packages = [pkgs.libwacom];

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
    monitors = myvars.hostsConfig.monitors.laptop;
  };

  modules.desktop.fonts.system.enable = true;
  modules.desktop.displayManager.enable = true;
  modules.desktop.wallpaper = {
    enable = true;
    file = myvars.hostsConfig.wallpaper;
  };

  modules.services.gdrive.enable = true;
  modules.editors.neovim.system.enable = true;

  modules.programs.virtualization.system.enable = true;
  modules.programs.fhs.system.enable = true;

  system.stateVersion = "25.11";
}
