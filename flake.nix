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
    walls = {
      url = "git+file:///home/dtsf/.dotfiles/modules/walls?shallow=1";
      flake = false;
    };
    unix-scripts = {
      url = "git+file:///home/dtsf/.dotfiles/dotfiles/bin?shallow=1";
      flake = false;
    };

    # third party
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    minegrub-theme.url = "github:Lxtharia/minegrub-theme?rev=9644b8b30e5323df3d61cb6a1284dd0be1cf73b6";
    ags.url = "github:Aylur/ags";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      vars = {
        user = "dtsf";
        host = "dtsf-machine";
        environment = {
          term = "alacritty";
          shell = "fish";
          wm = "i3";
        };
        appearance = {
          wall = "19.png";
          colorscheme = "gruvbox";
        };
        applications = {
          browser = "chromium";
        };
        system = {
          load_nvidia_module = true;
        };
      };
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
