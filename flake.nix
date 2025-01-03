{
  description = "description";
  inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    datsnvim = {
      flake = false;
      url = "git+file:///home/dtsf/.dotfiles/home/base/tui/editors/neovim/conf?shallow=1";
    };
    unix-scripts = {
      flake = false;
      url = "git+file:///home/dtsf/.dotfiles/home/linux/base/scripts/conf?shallow=1";
    };
  };
  outputs = inputs: import ./outputs inputs;
}