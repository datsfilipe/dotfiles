{ lib, builtins, ... }:

with lib; let
  if_let = v: p: if attrsets.matchAttrs p v then v else null;
  match = v: l: builtins.elemAt
    (
      lists.findFirst
        (
          x: (if_let v (builtins.elemAt x 0)) != null
        )
        null
        l
    ) 1;

  getFiles = dir:
    let
      dirContents = builtins.readDir dir;
      handlePath = name: type:
        if type == "directory" 
        then getNixFiles (dir + "/${name}")
        else if type == "regular" && (lib.hasSuffix ".nix" name) && name != "default.nix"
        then [(dir + "/${name}")]
        else [];
      
      paths = lib.flatten (
        lib.mapAttrsToList handlePath dirContents
      );
    in
      paths;

  importAll = paths:
    map (p: import p) paths;

  removeSuffix = suffix: str:
    if lib.strings.hasSuffix suffix str
    then lib.strings.substring 0 (builtins.stringLength str - builtins.stringLength suffix) str
    else str;

  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));
in
{
  nixosSystem = import ./nixosSystem.nix;

  if_let = if_let;
  match = match;
  removeHash =
    str: builtins.replaceStrings [ "#" ] [ "" ] str;
  relativeToRoot = lib.path.append ../.;
  getFiles = getFiles;
  importAll = importAll;
  removeSuffix = removeSuffix;
  scanPaths = scanPaths;
}
