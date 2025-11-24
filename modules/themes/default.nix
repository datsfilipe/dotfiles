{mylib, ...}: {
  imports = mylib.file.scanPaths ./. ".nix";
}
