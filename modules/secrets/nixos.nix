{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
with lib; let
  authsock = "/run/user/$(id -u)/ssh-agent.socket";
in {
  options.modules.ssh-key-manager = {
    enable = mkEnableOption "SSH key management service";
  };

  config = mkIf config.modules.ssh-key-manager.enable {
    sops = {
      age.generateKey = false;
      age.sshKeyPaths = ["/home/${myvars.username}/.ssh/alt_key"];
      age.keyFile = "/home/${myvars.username}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets."ssh/pass/primary" = {
        owner = myvars.username;
      };
      secrets."token/github/dtsf-pc" = {
        owner = myvars.username;
      };
      secrets."hosts" = {
        owner = myvars.username;
      };
    };

    programs.bash.interactiveShellInit = ''
      export GH_TOKEN="$(cat ${config.sops.secrets."token/github/dtsf-pc".path})"
    '';

    environment.systemPackages = [
      (pkgs.writeScriptBin "get-gh-token" ''
        #!${pkgs.bash}/bin/bash
        cat ${config.sops.secrets."token/github/dtsf-pc".path}
      '')
    ];

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
