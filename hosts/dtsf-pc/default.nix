{ lib, mylib, ... }:
let
  hostName = "dtsf-pc";
in {
  imports =
    [./hardware-configuration.nix]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

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
  modules.hardware.nvidia.system.enable = true;
  modules.hardware.monitors = {
    enable = true;
    enableNvidiaSupport = true;
    monitors = [
      {
        name = "DP-2";
        focus = true;
        resolution = "1920x1080";
        refreshRate = "180";
        nvidiaSettings = {
          coordinate = {
            x = 0;
            y = 15;
          };
          forceFullCompositionPipeline = true;
          rotation = "normal";
        };
      }
      {
        name = "HDMI-0";
        resolution = "1920x1080";
        refreshRate = "75";
        scale = "1.1";
        nvidiaSettings = {
          coordinate = {
            x = 1920;
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
  modules.desktop.wms.i3.system.enable = true;

  modules.desktop.wallpaper = {
    enable = true;
    file = "/run/media/dtsf/datsgames/walls/46.png";
  };

  modules.editors.neovim.system.enable = true;
  modules.desktop.fonts.system.enable = true;

  modules.programs.virtualization.system.enable = true;
  modules.programs.fhs.system.enable = true;

  system.stateVersion = "25.05";
}
