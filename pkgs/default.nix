{pkgs}: {
  devtunnel = pkgs.callPackage ./devtunnel-cli.nix {};
  fetch = pkgs.callPackage ./fetch.nix {};
}
