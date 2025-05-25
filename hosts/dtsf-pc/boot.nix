{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

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
        menuentry "Windows" {
          insmod part_gpt
          insmod fat
          insmod search_fs_uuid
          insmod chain
          search --fs-uuid --set=root F8D5-8832
          chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
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
