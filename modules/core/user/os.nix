{
  lib,
  myvars,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.user.system;
in {
  options.modules.core.user.system.enable = mkEnableOption "Primary user and base system packages";

  config = mkIf cfg.enable {
    users.groups = {
      "${myvars.username}" = {};
      docker = {};
      uinput = {};
    };

    users.users.${myvars.username} = {
      home = "/home/${myvars.username}";
      isNormalUser = true;
      description = myvars.userfullname;
      openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
      extraGroups = [
        myvars.username
        "users"
        "networkmanager"
        "wheel"
        "docker"
        "libvirtd"
        "video"
      ];
      linger = false;
    };

    environment.systemPackages = with pkgs; [
      fastfetch
      just
      fish
      git
      eza
      zip
      fzf
      unzip
      xz
      zstd
      p7zip
      gnugrep
      gawk
      jq
      dnsutils
      wget
      curl
      socat
      findutils
      which
      rsync
    ];
  };
}
