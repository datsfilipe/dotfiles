{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.kernelModules = ["amdgpu"];

  boot.kernelParams = ["amdgpu.dcfeaturemask=0x402"];

  boot.blacklistedKernelModules = ["hid_magicmouse" "hid_apple"];

  boot.loader = {
    grub.enable = false;
    systemd-boot.enable = true;

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  time.hardwareClockInLocalTime = true;
}
