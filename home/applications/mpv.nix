{ pkgs, ... }:

{
  xdg.configFile."mpv/scripts" = {
    source = ../../dotfiles/mpv;
    recursive = true;
  };

  programs.mpv = {
    enable = true;
    package = pkgs.mpv;
  };

  home.packages = with pkgs; [ socat ];
}
