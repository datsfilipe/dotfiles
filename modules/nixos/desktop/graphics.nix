{pkgs, ...}: {
  xdg.portal = {
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
