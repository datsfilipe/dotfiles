{
  lib,
  config,
  myvars,
  ...
}:
with lib; let
  cfg = config.modules.programs.archbox.system;
in {
  options.modules.programs.archbox.system.enable = mkEnableOption "Rootless podman backend for the Arch dev container";

  config = mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };

    users.users.${myvars.username}.autoSubUidGidRange = true;
  };
}
