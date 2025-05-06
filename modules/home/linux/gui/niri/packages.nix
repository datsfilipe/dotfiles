{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
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
