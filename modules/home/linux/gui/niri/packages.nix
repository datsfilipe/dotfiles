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
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    astal
    meow
  ];
}
