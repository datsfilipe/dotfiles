{
  inputs,
  lib,
  system,
  genSpecialArgs,
  darwin-modules,
  home-modules ? [],
  specialArgs ? (genSpecialArgs system),
  myvars,
  mylib,
  ...
}:
import ./system.nix {
  inherit lib system specialArgs home-modules myvars;
  systemModules = darwin-modules;
  systemConstructor = inputs.nix-darwin.lib.darwinSystem;
  homeManagerModule = inputs.home-manager.darwinModules.home-manager;
}
