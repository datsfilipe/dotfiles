{
  description = "dats shimeji flake";

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {system = "x86_64-linux";};
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [openjdk8-bootstrap ant];
      LD_LIBRARY_PATH = (pkgs.lib.makeLibraryPath [
        pkgs.xorg.libX11
        pkgs.xorg.libXrender
      ]) + ":${pkgs.openjdk8-bootstrap}/lib/amd64";
    };
  };
}
