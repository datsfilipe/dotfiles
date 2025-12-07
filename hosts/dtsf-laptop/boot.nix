{
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.kernelModules = ["i915"];

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
