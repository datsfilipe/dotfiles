{
  lib,
  config,
  pkgs,
  myvars,
  ...
}:
with lib; let
  authsock = "/run/user/$(id -u)/ssh-agent.socket";
in {
  options.modules.core.misc.ssh-manager = {
    enable = mkEnableOption "SSH management service";
  };

  config = mkIf config.modules.core.misc.ssh-manager.enable {
    environment.sessionVariables = {
      SSH_AUTH_SOCK = authsock;
    };

    systemd.user.services.ssh-key-manager = {
      description = "SSH Key Management Service";
      wantedBy = ["default.target"];
      path = [pkgs.expect];

      script = ''
        export SSH_AUTH_SOCK="${authsock}"
        ${pkgs.openssh}/bin/ssh-agent -a "$SSH_AUTH_SOCK" &
        sleep 1

        expect << EOF
        spawn ${pkgs.openssh}/bin/ssh-add /home/${myvars.username}/.ssh/main_key
        expect "enter passphrase"
        send "$(cat ${config.sops.secrets."ssh/pass/primary".path})\n"
        expect eof
        EOF

        wait
      '';
      serviceConfig = {
        KillMode = "mixed";
        Type = "forking";
        Environment = ["HOME=/home/${myvars.username}"];
      };
    };
  };
}
