{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.core.security.system;
in {
  options.modules.core.security.system.enable = mkEnableOption "Security defaults (sudo, polkit, gnupg)";

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    security.sudo.keepTerminfo = true;

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gtk2;
      enableSSHSupport = false;
      settings.default-cache-ttl = 4 * 60 * 60;
    };
  };
}
