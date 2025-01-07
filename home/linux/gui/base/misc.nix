{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    telegram-desktop
    flameshot
    pcmanfm
  ];

  fonts.fontconfig.enable = false;
}
