{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    xorg.xinit
    xorg.xrandr
    xorg.setxkbmap
    xclip
    i3status
    i3lock
    dconf
    networkmanagerapplet
  ];
}
