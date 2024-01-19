{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.tomato-c.defaultPackage.x86_64-linux
  ];
}
