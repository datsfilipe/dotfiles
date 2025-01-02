{ lib, builtins, ... }:

{
  utils = import ./utils.nix { inherit lib builtins; };
}
