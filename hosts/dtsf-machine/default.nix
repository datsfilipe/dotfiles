{ config, lib, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ]
    ++ (import ../../modules/desktops/virtualisation);

  boot = {
    kernelPackages = pkgs.linuxPackages_6_6_hardened;

    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;

      grub = {
        enable = true;
        efiSupport = true;
        devices = ["nodev"];
        useOSProber = true;
      };

      timeout = 4;
    };

    # wifi adapter driver
    initrd.kernelModules = [ "8821cu" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8821cu ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  networking = {
    hostName = "dtsf-machine";
    networkmanager.enable = true;
  };

  # disable networkmanager-wait-online
  systemd.services.NetworkManager-wait-online.enable = false;

  time.timeZone = "America/Belem";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
    };
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs = {
    nix-ld.enable = true;
  };
}
