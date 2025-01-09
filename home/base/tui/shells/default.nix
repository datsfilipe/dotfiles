{mylib, lib, config, pkgs-unstable, ...}: let
  pkgs = pkgs-unstable;
  localbin = "${config.home.homeDirectory}/.local/bin";
  gobin = "${config.home.homeDirectory}/go/bin";
  rustbin = "${config.home.homeDirectory}/.cargo/bin";
  path = "PATH=\"$PATH:${localbin}:${gobin}:${rustbin}\"";
in {
  imports = (map (module: import module { inherit lib pkgs path; }) (mylib.file.scanPaths ./.));
}
