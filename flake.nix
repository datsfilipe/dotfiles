{
  description = "datsdots";
  inputs = {
    ghostty.url = "github:ghostty-org/ghostty/main";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    datsnvim = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:datsfilipe/datsnvim/main";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    linux-shimeji = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:datsfilipe/linux-shimeji/main";
    };
    meow = {
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      url = "github:datsfilipe/meow/main";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix/master";
    };
    zellij-switch = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:datsfilipe/zellij-switch/flake";
    };
    unix-scripts = {
      flake = false;
      url = "git+file:///home/dtsf/.dotfiles/pkgs/scripts/conf?shallow=1";
    };
  };
  outputs = inputs: import ./outputs inputs;
}
