{
  lib,
  mylib,
  pkgs,
  myvars,
  nixpkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.nix.system;
  homeDir = "/home/${myvars.username}";
  configFile = "/etc/gc-paths.conf";
in {
  options.modules.core.nix.system.enable = mkEnableOption "Nix settings and store maintenance";

  config = mkIf cfg.enable {
    nix.package = pkgs.nixVersions.latest;
    nixpkgs.config.allowUnfree = mkForce true;

    nix.gc = {
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 7d";
    };

    nix.settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = [myvars.username];
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://${myvars.cache.cachix}.cachix.org"
      ];
      builders-use-substitutes = true;
      trusted-public-keys = myvars.cache.publicKeys;
    };

    nix.channel.enable = false;
    programs.command-not-found.enable = false;

    systemd.services.path-garbage-collector = {
      description = "Clean up old files from specified paths";
      path = [pkgs.findutils pkgs.coreutils];
      serviceConfig = {
        KillMode = "mixed";
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "cleanup-paths" (mylib.file.substitute ./conf/cleanup-paths.sh {
          "@configFile@" = configFile;
          "@homeDir@" = homeDir;
        });
      };
    };

    systemd.timers.path-garbage-collector = {
      description = "Timer for path garbage collector";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
        RuntimeMaxSec = 30;
      };
    };

    environment.etc."gc-paths.conf".text = ''
      ${homeDir}/.local/share/nvim/backup,7d
    '';
  };
}
