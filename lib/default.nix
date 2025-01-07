{ lib, builtins, ... }:

with lib; let
  if_let = v: p:
    let
      intersected = attrsets.intersectAttrs p v;
    in
      if intersected == p
      then v
      else null;

  match = v: l:
    builtins.foldl' (
      acc: x:
        if acc != null
        then acc
        else
          let
            candidate = builtins.elemAt x 0;
          in
            if (if_let v candidate) != null
            then builtins.elemAt x 1
            else acc
    ) null l;

  mapLookup = v: items: 
    if builtins.hasAttr v.value items then
      items.${v.value}
    else
      null;

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

  extractName = path: let
    parts = lib.splitString "/" path;
    lastPart = lib.last parts;
  in
    lib.replaceStrings [".nix"] [""] lastPart;
in
{
  nixosSystem = import ./nixosSystem.nix;

  if_let = if_let;
  match = match;
  mapLookup = mapLookup;
  removeHash =
    str: builtins.replaceStrings [ "#" ] [ "" ] str;
  relativeToRoot = lib.path.append ../.;
  getFiles = getFiles;
  importAll = importAll;
  removeSuffix = removeSuffix;
  scanPaths = scanPaths;
  extractName = extractName;
}
