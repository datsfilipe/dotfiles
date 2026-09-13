{mylib, ...}: {
  imports =
    [
      ./hardware-configuration.nix
      ./boot.nix
      ./services/nginx.nix
      ./services/dashboard.nix
      ./services/apps.nix
      (import ../common/nixos-base.nix {hostName = "dtsf-server";})
    ]
    ++ (mylib.file.scanPaths ../../modules "os.nix");

  modules.editors.neovim.system.enable = true;

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "26.05";
}
