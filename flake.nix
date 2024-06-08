{
  description = "Dats NixOS dotfiles from datsfilipe.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    datsnvim = {
      url = "git+file:///home/dtsf/.dotfiles/dotfiles/nvim?shallow=1";
      flake = false;
    };
    walls = {
      url = "git+file:///home/dtsf/.dotfiles/modules/walls?shallow=1";
      flake = false;
    };
    unix-scripts = {
      url = "git+file:///home/dtsf/.dotfiles/dotfiles/bin?shallow=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      vars = { user = "dtsf"; };
    in {
      nixosConfigurations = (
        import ./core {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager vars;
      });
    };
}
