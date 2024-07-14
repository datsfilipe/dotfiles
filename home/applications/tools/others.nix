{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
    trash-cli
    zoxide
    file
    p7zip
    unar
    zip
    unzip
  ];
}
