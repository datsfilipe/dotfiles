{
  description = "datsdots";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    datsnvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:datsfilipe/datsnvim/main";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/master";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix/master";
    };
    zellij-switch = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:datsfilipe/zellij-switch/master";
    };
    unix-scripts = {
      flake = false;
      url = "github:datsfilipe/unix-scripts/main";
    };
  };
  outputs = inputs: import ./outputs inputs;
}
