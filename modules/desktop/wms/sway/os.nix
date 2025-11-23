{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wms.sway.system;
in {
  options.modules.desktop.wms.sway.system.enable = mkEnableOption "Sway (Wayland) system support";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
      config.common.default = ["gnome"];
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    programs.sway.wrapperFeatures.gtk = true;
    environment.pathsToLink = ["/libexec"];

    modules.desktop.displayManager.enable = mkDefault true;
    modules.desktop.displayManager.sessions.sway = {
      name = "Sway (Wayland)";
      command = "exec sway";
    };
  };
}
