{
  description = "dats rust shell";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          packages = [
            pkg-config
            openssl
          ];
          env = {
            PKG_CONFIG_PATH = "${openssl.dev.outPath}/lib/pkgconfig:" + "$PKG_CONFIG_PATH";
          };
          buildInputs = [
            (rust-bin.beta.latest.default.override {
              extensions = [ "rust-src" ];
              targets = [ "wasm32-wasi" ];
            })
          ];
        };
      }
    );
}
