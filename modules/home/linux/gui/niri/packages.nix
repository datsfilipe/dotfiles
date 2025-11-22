{
  config,
  lib,
  pkgs,
  mypkgs,
  ...
}:
with lib; {
  config = mkIf config.modules.desktop.niri.enable {
    home.packages = with pkgs; [
      yad
      niri
      dunst
      fuzzel
      wl-clipboard
    ];

    modules.desktop.nupkgs.packages = with mypkgs; [
      astal
    ];
  };
}
