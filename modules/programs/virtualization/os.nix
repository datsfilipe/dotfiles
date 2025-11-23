{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.programs.virtualization.system;
in {
  options.modules.programs.virtualization.system.enable = mkEnableOption "Docker virtualization stack";

  config = mkIf cfg.enable {
    boot.kernelModules = ["vfio-pci"];

    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        "features" = {"containerd-snapshotter" = true;};
      };
      enableOnBoot = true;
    };

    environment.systemPackages = with pkgs; [docker docker-compose];
  };
}
