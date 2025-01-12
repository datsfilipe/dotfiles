{
  myvars,
  pkgs,
  lib,
  ...
}: let
  homeDir = "/home/${myvars.username}";
  configFile = "/etc/gc-paths.conf";
in {
  systemd.services.path-garbage-collector = {
    description = "Clean up old files from specified paths";
    path = [pkgs.findutils pkgs.coreutils];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "cleanup-paths" ''
          while IFS=, read -r path age; do
            if [ -d "$path" ]; then
              find "$path" -type f -mtime +"''${age%d}" -delete 2>/dev/null
                fi
                done < ${configFile}

        find / -type d \( -name ".trash" -o -name ".Trash" -o -name ".Trash-1000" \) -exec $(which rm) -rf {} + 2>/dev/null || true
      '';
    };
  };

  systemd.timers.path-garbage-collector = {
    description = "Timer for path garbage collector";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  environment.etc."gc-paths.conf".text = ''
    ${homeDir}/.local/share/nvim/backup,7d
  '';
}
