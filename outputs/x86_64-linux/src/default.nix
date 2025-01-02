{ mylib, ... }:

with mylib; let
  hosts = getFiles ./.;
  hosts' = importAll hosts;
in
  hosts'
