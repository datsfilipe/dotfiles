{
  description = "dats nixos dotfiles from datsfilipe.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # git modules
    datsnvim = {
      url = "git+file:///home/dtsf/.dotfiles/dotfiles/nvim?shallow=1";
      flake = false;
    };
    unix-scripts = {
      url = "git+file:///home/dtsf/.dotfiles/dotfiles/bin?shallow=1";
      flake = false;
    };

    # third party
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    ags.url = "github:aylur/ags";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      mkhost = hostname:
        let
          vars = import (./hosts + "/${hostname}/host-configuration.nix") { inherit lib; };
        in (
          import ./modules/system {
            inherit nixpkgs lib inputs home-manager vars;
          }
        );
    in
    {
      nixosConfigurations = {
        "dtsf-machine" = mkhost "dtsf-machine";
        "dtsf-book" = mkhost "dtsf-book";
      };
    };
}
