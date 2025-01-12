{
  description = "dats nodejs shell";

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
        nodejs_latest
        nodejs_latest.pkgs.pnpm
        nodejs_latest.pkgs.yarn
      ];
    in
      with pkgs; {
        devShells.default = mkShell {
          name = "nodejs";
          packages = inputs;
        };
      });
}
