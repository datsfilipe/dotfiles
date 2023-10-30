{
  inputs,
  nixpkgs,
  vars,
  ...
}: let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  dtsf-machine = lib.nixosSystem {
    inherit system;
    modules = [
      ./configuration.nix
    ];
  };
}
