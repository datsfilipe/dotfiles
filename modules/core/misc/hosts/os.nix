{
  config,
  pkgs,
  ...
}: {
  systemd.services.apply-hosts = {
    description = "Apply custom hosts entries";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      KillMode = "mixed";
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.gnused}/bin/sed -i \"$ r ${config.sops.secrets."hosts".path}\" /etc/hosts'";
    };
  };
}
