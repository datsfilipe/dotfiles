{
  inputs,
  nixpkgs,
  vars,
  home-manager,
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
    specialArgs = { inherit inputs vars; };

    modules = [
      ./configuration.nix
      ./packages.nix
      ../home/services/udisks2.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${vars.user} = {
            imports = (
              import ../home
            );

            home.sessionPath = [
              "$HOME/.local/bin"
            ];

            home.stateVersion = "24.05";
            programs.home-manager.enable = true;
          };
        };
      }
    ];
  };
}
