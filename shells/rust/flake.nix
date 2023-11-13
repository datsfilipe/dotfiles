{
  description = "dats rust shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inputs = with pkgs; [
          rustc
          cargo
        ];
      in with pkgs; {
        devShells.default = mkShell {
          name = "rust";
          packages = inputs;
        };
      });
}
