{
  pkgs,
  lib,
  ...
}: {
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
}
