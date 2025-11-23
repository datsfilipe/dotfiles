{mylib, ...} @ args:
map
(path: import path args)
(mylib.file.scanPaths ./. ".nix")
