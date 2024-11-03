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
      systemd-boot.enable = vars.system.boot == "systemd";
      efi.canTouchEfiVariables = true;
      timeout = 4;
    };
  };

  boot.loader.grub = mkIf (vars.system.boot == "grub") {
    enable = vars.system.boot == "grub";
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
    gfxmodeEfi = "1920x1080";
    minegrub-theme = {
      enable = true;
      splash = vars.host;
      boot-options-count = 4;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  networking = {
    hostName = "dtsf-machine";
    useHostResolvConf = false;
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    };
    extraHosts = ''
      127.0.0.1 host.docker.internal
      127.0.0.1 localhost ote.identitydigital.services
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

  hardware.bluetooth.enable = true;
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
