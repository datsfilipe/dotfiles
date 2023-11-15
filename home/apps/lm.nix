{ inputs, pkgs, ... }:

{
  home.packages = with pkgs; [
    inputs.list-manager.packages.${pkgs.system}.default
  ];
}
