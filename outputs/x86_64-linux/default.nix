{
  lib,
  mylib,
  inputs,
  ...
} @ args: let
  data = import ./src {
    inherit lib inputs args mylib;
  };

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (map (it: it.nixosConfigurations or {}) data);
    packages = lib.attrsets.mergeAttrsList (map (it: it.packages or {}) data);
  };
in
  outputs // {
    inherit data;
  }
