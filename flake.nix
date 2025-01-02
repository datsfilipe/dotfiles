{
  description = "datsfilipe's dotfiles";

  outputs = inputs: import ./outputs inputs;

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # datsnvim = {
    #   url = "git+file:///home/dtsf/.dotfiles/dotfiles/nvim?shallow=1";
    #   flake = false;
    # };
    # unix-scripts = {
    #   url = "git+file:///home/dtsf/.dotfiles/dotfiles/bin?shallow=1";
    #   flake = false;
    # };
  };
}
