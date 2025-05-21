{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  myvars,
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
    udisks2.enable = true;
    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess", TAG+="udev-acl", GROUP="${myvars.username}"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", GROUP="video", MODE="0664"
    '';
  };

  programs = {
    ssh.startAgent = false;
    dconf.enable = true;
  };

  gtk.iconCache.enable = true;
}
