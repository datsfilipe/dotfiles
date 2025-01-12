{pkgs, ...}: {
  boot.kernelModules = ["vfio-pci"];

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        "features" = {"containerd-snapshotter" = true;};
      };

      enableOnBoot = true;
    };
  };

  environment.systemPackages = with pkgs; [docker docker-compose];
}
