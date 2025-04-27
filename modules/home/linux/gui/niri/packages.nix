{
  pkgs,
  mypkgs,
  ...
}: {
  home.packages = with pkgs; [
    niri
    fuzzel
    dunst
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    astal
  ];
}
