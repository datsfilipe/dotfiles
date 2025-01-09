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

  formatSections = categories: attrs: let
    escapeValue = value:
      if builtins.isList value then
        "[\n  " + (lib.concatStringsSep ",\n  " (map (x: builtins.toJSON x) value)) + ",\n]"
      else if builtins.isInt value || builtins.isFloat value then
        toString value
      else if value == true then
        "true"
      else if value == false then
        "false"
      else
        ''"${value}"'';
        
    toIniLine = key: value:
      "${key}=${escapeValue value}";
        
    processAttributes = attributes:
      lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: toIniLine k v) attributes);
      
    effectiveCategories = if categories == null then lib.attrNames attrs else categories;
  in
    (if effectiveCategories == [] then
      processAttributes attrs
    else
      lib.concatStringsSep "\n\n" (
        map (category: ''
          [${category}]
          ${processAttributes (attrs.${category} or {})}
        '') effectiveCategories
      )) + "\n";

  hexToDec = c: 
    let
      hexChars = {
        "0" = 0; "1" = 1; "2" = 2; "3" = 3; "4" = 4;
        "5" = 5; "6" = 6; "7" = 7; "8" = 8; "9" = 9;
        "a" = 10; "b" = 11; "c" = 12; "d" = 13; "e" = 14; "f" = 15;
        "A" = 10; "B" = 11; "C" = 12; "D" = 13; "E" = 14; "F" = 15;
      };
    in hexChars.${c};
  decToHex = n:
    if n < 10 then toString n
    else {
      "10" = "a"; "11" = "b"; "12" = "c";
      "13" = "d"; "14" = "e"; "15" = "f";
    }.${toString n};
  hexPairToDec = hex: hexToDec (builtins.substring 0 1 hex) * 16 + hexToDec (builtins.substring 1 1 hex);
  decToHexPair = n: decToHex (n / 16) + decToHex (n - (n / 16 * 16));

  darkenHex = hex: factor:
    let
      cleanHex = builtins.replaceStrings ["#"] [""] (lib.toLower hex);
      r = hexPairToDec (builtins.substring 0 2 cleanHex);
      g = hexPairToDec (builtins.substring 2 2 cleanHex);
      b = hexPairToDec (builtins.substring 4 2 cleanHex);
      
      darkR = builtins.ceil (r * (1 - factor));
      darkG = builtins.ceil (g * (1 - factor));
      darkB = builtins.ceil (b * (1 - factor));

      clamp = n: if n < 0 then 0 else if n > 255 then 255 else n;
    in
      "#" + decToHexPair (clamp darkR) + decToHexPair (clamp darkG) + decToHexPair (clamp darkB);
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
  formatSections = formatSections;
  darkenHex = darkenHex;
}
