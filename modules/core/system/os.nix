{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.core.system;
in {
  options.modules.core.system.enable = mkEnableOption "Base system packages and misc defaults";

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc
      strace
      tcpdump
      lsof
      sysstat
      iotop
      iftop
      psmisc
      lm_sensors
      ethtool
      pciutils
      usbutils
      parted
      openvpn
      gnumake
      udiskie
      gum
      (pkgs.writeScriptBin "get-gh-token" ''
        #!${pkgs.bash}/bin/bash
        cat ${config.sops.secrets."token/github/dtsf-pc".path}
      '')
    ];

    environment.shells = [pkgs.bashInteractive];
    users.defaultUserShell = pkgs.bashInteractive;
    security.sudo.keepTerminfo = true;

    environment.variables = {
      TZ = "${config.time.timeZone}";
    };

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
      udev.extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", TAG+="uaccess", TAG+="udev-acl", GROUP="video"
        ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="*", GROUP="video", MODE="0664"
      '';
    };

    programs = {
      ssh.startAgent = false;
      dconf.enable = true;
    };

    gtk.iconCache.enable = true;

    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "4s";
    };
  };
}
