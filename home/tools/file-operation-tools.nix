{ pkgs, ... }:

{
  home.packages = with pkgs; [
    file
    p7zip
    unar
    zip
    unzip
  ];
}
