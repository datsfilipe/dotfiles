{ config, lib, pkgs, vars, ... }:

with lib; {
  imports =
    [
      (./. + "/../${vars.host}/hardware-configuration.nix")
      ./nvidia.nix
    ] ++ (import ../../modules/desktops/virtualisation);

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = mkIf (vars.boot == "grub") true;
      efi.canTouchEfiVariables = true;

      grub = {
        enable = mkIf (vars.boot == "grub") true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        gfxmodeEfi = "1920x1080";

        minegrub-theme = {
          enable = true;
          splash = "dtsf-machine!";
          boot-options-count = 4;
        };
      };

      timeout = 4;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking = {
    hostName = "dtsf-machine";
    networkmanager.enable = true;
    extraHosts = ''
      127.0.0.1 host.docker.internal
    '';
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
