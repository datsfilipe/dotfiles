{mylib, ...} @ args: let
  paths =
    builtins.filter (p: p != ./default.nix)
    (mylib.file.scanPaths ./. ".nix");
in
  map (path: import path args) paths
