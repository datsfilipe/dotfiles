{
  description = "dats nodejs shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inputs = with pkgs; [
          nodejs_21
          nodejs_21.pkgs.pnpm
          nodejs_21.pkgs.yarn
        ];
      in with pkgs; {
        devShells.default = mkShell {
          name = "nodejs";
          packages = inputs;
        };
      });
}
