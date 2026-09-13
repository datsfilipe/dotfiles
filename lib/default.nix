{
  lib,
  builtins,
  ...
}:
with lib; let
  mapLookup = v: items:
    if builtins.hasAttr v.value items
    then items.${v.value}
    else null;

  removeSuffix = suffix: str:
    if lib.strings.hasSuffix suffix str
    then lib.strings.substring 0 (builtins.stringLength str - builtins.stringLength suffix) str
    else str;
in {
  mapLookup = mapLookup;
  removeHash = str: builtins.replaceStrings ["#"] [""] str;
  removeSuffix = removeSuffix;

  nixosSystem = import ./nixosSystem.nix;
  darwinSystem = import ./darwinSystem.nix;
  format = import ./format.nix {inherit lib builtins;};
  file = import ./file.nix {inherit lib builtins;};
  color = import ./color.nix {inherit lib builtins;};
}
