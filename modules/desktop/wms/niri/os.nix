{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.desktop.wms.niri.system;

  niriSession = pkgs.writeShellScriptBin "custom-niri-session" ''
    if systemctl --user -q is-active niri.service; then
      echo 'a niri session is already running.'
      exit 1
    fi

    systemctl --user reset-failed

    if hash dbus-update-activation-environment 2>/dev/null; then
      dbus-update-activation-environment --all
    fi

    systemctl --user --wait start niri.service
    systemctl --user start --job-mode=replace-irreversibly niri-shutdown.target
    systemctl --user unset-environment WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP NIRI_SOCKET GDK_BACKEND
  '';
in {
  options.modules.desktop.wms.niri.system.enable = mkEnableOption "Niri (Wayland) system support";

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
