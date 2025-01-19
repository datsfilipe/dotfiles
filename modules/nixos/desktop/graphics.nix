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

    # xdgOpenUsePortal = false;
    # extraPortals = with pkgs; [
    #   xdg-desktop-portal-gtk
    # ];
  };
}
