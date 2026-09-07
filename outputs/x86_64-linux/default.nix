{
  lib,
  mylib,
  inputs,
  system,
  ...
} @ args:
import ../../lib/loadOutputs.nix {
  inherit lib mylib args;
  directory = ./src;
  outputName = "nixosConfigurations";
}
