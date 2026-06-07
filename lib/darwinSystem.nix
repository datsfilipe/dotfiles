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
}: let
  inherit (inputs) nixpkgs nix-darwin home-manager;
in
  nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules =
      darwin-modules
      ++ (
        lib.optionals ((lib.lists.length home-modules) > 0)
        [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm.backup";

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users."${myvars.username}".imports = home-modules;
          }
        ]
      );
  }
