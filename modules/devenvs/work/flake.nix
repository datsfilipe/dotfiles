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
        nodejs_20
        nodejs_20.pkgs.pnpm
        nodejs_20.pkgs.yarn
        libuuid
      ];
    in
      with pkgs; {
        devShells.default = mkShell {
          name = "nodejs";
          packages = inputs;
          env = {
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];
          };
        };
      });
}
