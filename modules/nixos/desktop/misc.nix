{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment.shells = with pkgs; [
    bashInteractive
  ];

  users.defaultUserShell = pkgs.bashInteractive;
  security.sudo.keepTerminfo = true;

  environment.variables = {
    TZ = "${config.time.timeZone}";
  };

  environment.systemPackages = with pkgs; [
    gnumake
  ];

  services = {
    gvfs.enable = true;
  };

  programs = {
    ssh.startAgent = true;
    dconf.enable = true;
  };
}
