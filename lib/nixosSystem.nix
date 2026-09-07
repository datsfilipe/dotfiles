{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [],
  specialArgs ? (genSpecialArgs system),
  myvars,
  mylib,
  ...
}:
import ./system.nix {
  inherit lib system specialArgs home-modules myvars;
  systemModules = nixos-modules;
  systemConstructor = inputs.nixpkgs.lib.nixosSystem;
  homeManagerModule = inputs.home-manager.nixosModules.home-manager;
}
