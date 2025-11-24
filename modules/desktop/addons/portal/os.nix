{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.addons.portal.system;
in {
  options.modules.desktop.addons.portal.system.enable = mkEnableOption "Generic xdg-desktop-portal defaults";

  config = mkIf cfg.enable {
    xdg.portal = lib.mkDefault {
      enable = true;

      config = {
        common = {
          default = [
            "gtk"
          ];
        };
      };

      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
