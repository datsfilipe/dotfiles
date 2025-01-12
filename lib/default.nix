{
  lib,
  builtins,
  ...
}:
with lib; let
  if_let = v: p: let
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
        else let
          candidate = builtins.elemAt x 0;
        in
          if (if_let v candidate) != null
          then builtins.elemAt x 1
          else acc
    )
    null
    l;

  mapLookup = v: items:
    if builtins.hasAttr v.value items
    then items.${v.value}
    else null;

  removeSuffix = suffix: str:
    if lib.strings.hasSuffix suffix str
    then lib.strings.substring 0 (builtins.stringLength str - builtins.stringLength suffix) str
    else str;

  extractName = path: let
    parts = lib.splitString "/" path;
    lastPart = lib.last parts;
  in
    lib.replaceStrings [".nix"] [""] lastPart;
in {
  if_let = if_let;
  match = match;
  mapLookup = mapLookup;
  removeHash = str: builtins.replaceStrings ["#"] [""] str;
  removeSuffix = removeSuffix;
  extractName = extractName;

  nixosSystem = import ./nixosSystem.nix;
  format = import ./format.nix {inherit lib builtins;};
  file = import ./file.nix {inherit lib builtins;};
  color = import ./color.nix {inherit lib builtins;};
}
