{pkgs, ...}: {
  home.packages = with pkgs; [
    xorg.setxkbmap
    xorg.xinit
    xorg.xrandr
    autorandr
    xss-lock
    dex
    xclip
    i3lock-color
    networkmanagerapplet
    dmenu
    dunst
  ];
}
