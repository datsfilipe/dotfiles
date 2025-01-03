{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    telegram-desktop
    flameshot
  ];

  fonts.fontconfig.enable = false;
}
