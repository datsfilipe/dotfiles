{
  lib,
  mylib,
  ...
}: let
  hostName = "dtsf-laptop";
in {
  imports =
    [./hardware-configuration.nix]
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

  modules.hardware.audio.system.enable = true;
  modules.hardware.bluetooth.system.enable = true;
  modules.hardware.nvidia.system.enable = false;
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

  modules.desktop.displayManager.enable = true;
  modules.desktop.wms.niri.system.enable = true;
  modules.desktop.wms.sway.system.enable = false;
  modules.desktop.wms.i3.system.enable = false;

  modules.desktop.wallpaper = {
    enable = true;
    file = "/home/${hostName}/media/photos/09.png";
  };

  modules.editors.neovim.system.enable = true;
  modules.desktop.fonts.system.enable = true;

  modules.programs.virtualization.system.enable = true;
  modules.programs.fhs.system.enable = true;

  system.stateVersion = "25.05";
}
