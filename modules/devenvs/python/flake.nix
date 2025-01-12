{
  description = "dats python shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      inputs = with pkgs; [
        python3
        python3Packages.virtualenv
        python3Packages.pip
        python3Packages.setuptools
      ];
    in
      with pkgs; {
        devShells.default = mkShell {
          name = "python";
          packages = inputs;
        };
      });
}
