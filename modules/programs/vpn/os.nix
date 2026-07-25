{
  lib,
  config,
  pkgs,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.programs.vpn;

  vpnScript = pkgs.writeShellApplication {
    name = "vpn";
    runtimeInputs = [pkgs.systemd pkgs.wireguard-tools pkgs.pritunl-client pkgs.jq pkgs.gum];
    text = builtins.readFile ./conf/vpn.sh;
  };
in {
  options.modules.programs.vpn = {
    enable = mkEnableOption "Personal (Proton WireGuard) + company (Pritunl) VPN switching";
    autostartPersonal = mkOption {
      type = types.bool;
      default = true;
      description = "Bring up the personal Proton tunnel at boot.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [vpnScript pkgs.pritunl-client pkgs.wireguard-tools];

    sops.secrets."vpn/proton" = {};

    networking.wg-quick.interfaces.proton = {
      autostart = cfg.autostartPersonal;
      configFile = config.sops.secrets."vpn/proton".path;
    };

    systemd.services.pritunl-client = {
      description = "Pritunl Client Service";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.pritunl-client}/bin/pritunl-client-service";
        Restart = "always";
      };
    };

    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
            action.lookup("unit") == "wg-quick-proton.service" &&
            subject.user == "${myvars.username}") {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
