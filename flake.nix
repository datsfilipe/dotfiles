{
  description = "Dats NixOS dotfiles from datsfilipe.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      vars = { user = "dtsf"; };
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager vars;
      });
    };
}
