{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.blacklistedKernelModules = ["hid_magicmouse" "hid_apple"];

  boot.loader = {
    grub.enable = false;

    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "keep";
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  time.hardwareClockInLocalTime = true;
}
