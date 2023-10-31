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
    modules = [
      ./hardware-configuration.nix
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${vars.user} = {
            imports = [
              ../home/packages.nix
              ../home/tmux.nix
              ../home/htop.nix
              ../home/hyprland.nix
              ../home/wezterm.nix
            ];
              
            home.stateVersion = "23.05";
            programs.home-manager.enable = true;
          };
        };
      }
    ];
  };
}
