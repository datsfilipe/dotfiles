{
  description = "dats elixir shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        inputs = with pkgs; [
          erlang
          elixir
        ];
      in with pkgs; {
        devShells.default = mkShell {
          name = "elixir";
          packages = inputs;
        };
      });
}
