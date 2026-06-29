{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  networking.extraHosts = lib.concatStringsSep "\n" (
    lib.concatMap (h: ["127.0.0.1 ${h}" "::1 ${h}"]) myvars.blockedHosts
  );

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
