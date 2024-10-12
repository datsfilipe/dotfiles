{ pkgs, vars, ... }:

let
  localPkgs = import ../../pkgs { pkgs = pkgs; };
  customPkgs = with localPkgs; [
    devtunnel
  ];
in
{
  imports = [
    (import (./. + "/../../hosts/${vars.host}/packages.nix") {
      inherit pkgs customPkgs;
    })
  ];

  services.openssh.enable = true;
  services.udisks2.enable = true;
}
