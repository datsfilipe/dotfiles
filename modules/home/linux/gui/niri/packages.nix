{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    yad
    niri
    dunst
    fuzzel
    wl-clipboard
    brightnessctl
    networkmanagerapplet
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    astal
    meow
  ];
}
