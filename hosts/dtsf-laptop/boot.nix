{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics.enable = true;
  boot.kernelParams = ["i915.enable_guc=0"];

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
