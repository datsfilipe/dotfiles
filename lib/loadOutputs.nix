{
  lib,
  mylib,
  directory,
  outputName,
  args,
}: let
  files = builtins.attrNames (builtins.readDir directory);
  data =
    lib.foldl' (
      acc: fileName: let
        name = mylib.removeSuffix ".nix" fileName;
      in
        acc // {"${name}" = import (directory + "/${fileName}") args;}
    ) {}
    files;
in {
  "${outputName}" = lib.attrsets.mergeAttrsList (
    map (value: value.${outputName} or {}) (builtins.attrValues data)
  );
  inherit data;
}
