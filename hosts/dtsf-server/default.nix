{
  pkgs,
  lib,
  myvars,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./boot.nix
  ];

  networking.hostName = "dtsf-server";

  services.filebrowser = {
    enable = true;
    port = 8080;
    user = myvars.username;
    group = "users";
    root = "/home/${myvars.username}";
    openFirewall = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = myvars.username;
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # port 25565
    jvmOpts = "-Xmx4G -Xms2G";
  };

  users.users.${myvars.username}.extraGroups = ["minecraft"];

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
}
