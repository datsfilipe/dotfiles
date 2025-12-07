{
  description = "datsdots";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    ags = {
      inputs = {
        astal.follows = "astal";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:aylur/ags/e169694390548dfd38ff40f1ef2163d6c3ffe3ea";
    };
    astal = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:aylur/astal/7d1fac8a4b2a14954843a978d2ddde86168c75ef";
    };
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
