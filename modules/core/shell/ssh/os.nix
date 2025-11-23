{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.core.shell.ssh.system;
in {
  options.modules.core.shell.ssh.system.enable = mkEnableOption "OpenSSH service";

  config = mkIf cfg.enable {
    networking.firewall.enable = mkDefault false;

    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    environment.enableAllTerminfo = true;
  };
}
