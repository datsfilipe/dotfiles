{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wm.niri.system;

  niriSession = pkgs.writeShellScriptBin "custom-niri-session" (builtins.readFile ./conf/custom-niri-session.sh);
in {
  options.modules.desktop.wm.niri.system.enable = mkEnableOption "Niri (Wayland) system support";

  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          default = ["gnome"];
        };
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    programs.sway.wrapperFeatures.gtk = true;
    environment.pathsToLink = ["/libexec"];

    modules.desktop.displayManager.enable = mkDefault true;
    modules.desktop.displayManager.sessions.niri = {
      name = "Niri (Wayland)";
      command = "exec ${niriSession}/bin/custom-niri-session";
    };
  };
}
