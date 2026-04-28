{
  pkgs,
  lib,
  ...
}: let
  themeDir = ../../pkgs/refind-theme;
in {
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.blacklistedKernelModules = ["hid_magicmouse" "hid_apple"];

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = false;

    refind = {
      enable = true;
      efiInstallAsRemovable = true;
      maxGenerations = 10;
      extraConfig = ''
        include themes/dtsf/theme.conf
      '';
      additionalFiles = {
        "EFI/refind/themes/dtsf/theme.conf" = themeDir + "/theme.conf";
      };
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  time.hardwareClockInLocalTime = true;
}
