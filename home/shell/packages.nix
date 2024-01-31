{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
    trash-cli
    zoxide
  ];
}
