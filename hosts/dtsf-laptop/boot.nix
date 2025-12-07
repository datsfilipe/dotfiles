{
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.enableRedistributableFirmware = true;
  boot.initrd.kernelModules = ["i915"];
  boot.kernelParams = ["i915.modeset=1"];
  services.xserver.videoDrivers = lib.mkForce ["modesetting"];

  boot.loader = {
    systemd-boot.enable = false;

    efi.efiSysMountPoint = "/boot";
    grub = {
      devices = ["nodev"];
      efiSupport = true;
      enable = lib.mkDefault true;
      gfxmodeEfi = "1920x1080";
      efiInstallAsRemovable = true;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
  };

  time.hardwareClockInLocalTime = true;
}
