{mylib, ...} @ args: let
  paths =
    builtins.filter (path: path != ./default.nix)
    (mylib.file.scanPaths ./. ".nix");
in
  map (path: import path args) paths
