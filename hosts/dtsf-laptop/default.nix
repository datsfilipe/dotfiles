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

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            a = "overloadt(meta, a, 250)";
            s = "overloadt(alt, s, 250)";
            d = "overloadt(control, d, 250)";
            f = "overloadt(shift, f, 250)";
            j = "overloadt(shift, j, 250)";
            k = "overloadt(control, k, 250)";
            l = "overloadt(alt, l, 200)";
            semicolon = "overloadt(meta, semicolon, 250)";
          };
        };
      };
    };
  };

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

  boot.resumeDevice = "/dev/disk/by-uuid/98e8d82d-ecb5-4977-bf07-f4430cf4d500";

  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchDocked = "ignore";
    HandlePowerKey = "hibernate";
  };

  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  system.stateVersion = "25.11";
}
