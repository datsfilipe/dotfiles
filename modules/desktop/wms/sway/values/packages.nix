{pkgs, ...}: {
  home.packages = with pkgs; [
    wl-clipboard
    libappindicator-gtk3
    networkmanagerapplet
    wmenu
  ];
}
