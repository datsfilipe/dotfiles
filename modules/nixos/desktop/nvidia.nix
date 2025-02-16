{
  config,
  lib,
  ...
}:
with lib; {
  options.modules.desktop.nvidia = {
    enable = mkEnableOption "NVIDIA graphics drivers";
  };

  config = mkIf config.modules.desktop.nvidia.enable {
    environment.variables = mkIf config.modules.desktop.wayland.enable {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    boot.extraModprobeConfig = "options nvidia-drm modeset=1";
    boot.kernelParams = ["nvidia.NVreg_EnableGpuFirmware=0" "nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
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
      forceFullCompositionPipeline = true;
      nvidiaSettings = true;
      open = false;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
