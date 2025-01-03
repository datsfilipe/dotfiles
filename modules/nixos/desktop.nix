{
  pkgs,
  config,
  lib,
  myvars,
  ...
}:
with lib; let
  cfgWayland = config.modules.desktop.wayland;
  cfgXorg = config.modules.desktop.xorg;
in {
  imports = [
    ./base
    ../base.nix

    ./desktop
  ];

  options.modules.desktop = {
    wayland = {
      enable = mkEnableOption "wayland display server";
    };
    xorg = {
      enable = mkEnableOption "xorg display server";
    };
  };

  config = mkMerge [
    (mkIf cfgWayland.enable {
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
        ];
      };

      services = {
        xserver.enable = false;
      };
    })

    (mkIf cfgXorg.enable {
      services = {
        gvfs.enable = true;

        xserver = {
          enable = true;
          displayManager = {
            defaultSession = "hm-session";
          };
          xkb.layout = "us";
        };
      };
    })
  ];
}
