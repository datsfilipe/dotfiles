{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xorg.setxkbmap
    xorg.xinit
    xorg.xrandr
    autorandr
    xss-lock
    dex
    xclip
    i3status
    i3lock
    networkmanagerapplet
    dmenu
  ];
}
