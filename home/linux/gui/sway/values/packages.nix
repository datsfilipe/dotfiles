{pkgs, ...}: {
  home.packages = with pkgs; [
    dunst
    wl-clipboard
    libappindicator-gtk3
    networkmanagerapplet
    bemenu
  ];
}
