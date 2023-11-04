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
          extraSpecialArgs = { inherit inputs; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${vars.user} = {
            home.sessionPath = [
              "$HOME/.local/bin"
            ];

            imports = [
              ../home/home.nix
              ../home/packages.nix
              ../home/nvim.nix
              ../home/tmux.nix
              ../home/htop.nix
              ../home/hyprland.nix
              ../home/wezterm.nix
              ../home/dunst.nix
              ../home/zsh.nix
              ../home/ags.nix
              ../home/anyrun.nix
              ../home/gtk.nix
              ../home/wall.nix
              ../home/spicetify.nix
            ];

            home.stateVersion = "23.11";
            programs.home-manager.enable = true;
          };
        };
      }
    ];
  };
}
