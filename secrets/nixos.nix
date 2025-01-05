{ config, lib, pkgs, myvars, ... }:

with lib; let
  authsock = "/run/user/$(id -u)/ssh-agent.socket";
in {
  options.modules.ssh-key-manager = {
    enable = mkEnableOption "SSH key management service";
  };

  config = mkIf config.modules.ssh-key-manager.enable {
    sops = {
      age.generateKey = false;
      age.sshKeyPaths = [ "/home/${myvars.username}/.ssh/alt_key" ];
      age.keyFile = "/home/${myvars.username}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets."ssh/pass/primary" = {
        owner = myvars.username;
      };
    };

    environment.sessionVariables = {
      SSH_AUTH_SOCK = authsock;
    };

    systemd.user.services.ssh-key-manager = {
      description = "SSH Key Management Service";
      wantedBy = [ "default.target" ];
      path = [ pkgs.expect ];
      
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
        Type = "forking";
        Environment = [ "HOME=/home/${myvars.username}" ];
      };
    };
  };
}
