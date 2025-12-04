{
  pkgs-unstable,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.hardware.nvidia.system;
in {
  options.modules.hardware.nvidia.system.enable = mkEnableOption "NVIDIA graphics drivers";

  config = mkIf cfg.enable {
    environment.variables = mkIf (config.modules.desktop.wms.niri.system.enable || config.modules.desktop.wms.sway.system.enable) {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";
      GBM_BACKEND = "nvidia-drm";
    };

    boot.extraModprobeConfig = "options nvidia-drm modeset=1";

    boot.kernelParams = [
      "nvidia.NVreg_EnableGpuFirmware=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "module_blacklist=amdgpu"
    ];

    boot.initrd.kernelModules =
      config.boot.kernelModules
      ++ [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      modesetting.enable = true;
      powerManagement.enable = true;
      nvidiaSettings = true;
      open = false;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs-unstable; [
        nvidia-vaapi-driver
      ];
    };
  };
}
