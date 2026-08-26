{
  config,
  pkgs,
  lib,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.services.gdrive;
  mountPoint = "/home/${myvars.username}/gdrive";
in {
  options.modules.services.gdrive = {
    enable = mkEnableOption "Google Drive mounting via Rclone";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.rclone];

    sops.secrets."rclone/config" = {
      owner = myvars.username;
      path = "/home/${myvars.username}/.config/rclone/rclone.conf";
    };

    systemd.user.services.rclone-gdrive-mount = {
      description = "Mount Google Drive via Rclone";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      wantedBy = ["default.target"];

      path = [pkgs.coreutils pkgs.rclone];

      script = ''
        config_file=${lib.escapeShellArg config.sops.secrets."rclone/config".path}
        for attempt in $(seq 1 60); do
          if [ -r "$config_file" ]; then
            break
          fi
          if [ "$attempt" -eq 60 ]; then
            echo "Rclone secret config is not available: $config_file" >&2
            exit 1
          fi
          sleep 1
        done

        export PATH="/run/wrappers/bin:$PATH"
        fusermount -u "${mountPoint}" || true
        mkdir -p "${mountPoint}"

        rclone mount "gdrive:" "${mountPoint}" \
          --config="$config_file" \
          --vfs-cache-mode writes \
          --dir-cache-time 24h
      '';

      serviceConfig = {
        ExecStop = "/run/wrappers/bin/fusermount -u \"${mountPoint}\"";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };
  };
}
