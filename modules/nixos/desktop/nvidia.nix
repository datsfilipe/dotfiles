{pkgs, config, lib, ...}: with lib; {
  options.modules.desktop.nvidia = {
    enable = mkEnableOption "NVIDIA graphics drivers";
  };

  config = mkIf config.modules.desktop.nvidia.enable {
    boot.extraModprobeConfig = "options nvidia-drm modeset=1";
    boot.initrd.kernelModules = config.boot.kernelModules ++ [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      modesetting.enable = true;
      powerManagement.enable = true;
      forceFullCompositionPipeline = true;
      nvidiaSettings = true;
      open = false;
    };
  };
}
