{
  lib,
  mylib,
  inputs,
  system,
  ...
} @ args: let
  srcFiles = builtins.attrNames (builtins.readDir ./src);

  data =
    lib.foldl' (
      acc: fileName: let
        attrName = mylib.removeSuffix ".nix" fileName;
      in
        acc
        // {
          "${attrName}" = import ./src/${fileName} args;
        }
    ) {}
    srcFiles;

  outputs = {
    darwinConfigurations = lib.attrsets.mergeAttrsList (map (it: it.darwinConfigurations or {}) (builtins.attrValues data));
  };
in
  outputs
  // {
    inherit data;
  }
