{
  pkgs,
  lib,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  boot.kernelParams = ["i915.enable_guc=0"];

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
