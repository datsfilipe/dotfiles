{ inputs
, nixpkgs
, vars
, home-manager
, lib
, ...
}:
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.cudaSupport = lib.mkIf (vars.system.load_nvidia_module) true;
  };

  lib = nixpkgs.lib;
  mylib = (import ../../lib { inherit lib builtins; });
  theme = (import ../colorscheme { inherit mylib vars; }).theme;
in
{
  dtsf-machine = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs vars mylib theme; };

    modules = [
      ./configuration.nix
      ./packages.nix
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          extraSpecialArgs = { inherit inputs vars mylib theme; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${vars.user} = {
            imports = (
              import ../../home
            );

            home.sessionPath = [
              "$HOME/.local/bin"
            ];

            home.stateVersion = "24.05";
            programs.home-manager.enable = true;
          };
        };
      }

      # grub theme
      inputs.minegrub-theme.nixosModules.default
    ];
  };
}
