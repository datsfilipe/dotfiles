{
  description = "Dats NixOS dotfiles from datsfilipe.";

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
    minegrub-theme.url = "github:Lxtharia/minegrub-theme";
    ags.url = "github:Aylur/ags";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      vars = import ./config.nix;
    in
    {
      nixosConfigurations = (
        import ./modules/system {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager vars;
        }
      );
    };
}
