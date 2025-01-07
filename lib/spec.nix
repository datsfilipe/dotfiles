{ pkgs ? import <nixpkgs> {} }:
let
  inherit (pkgs) lib;
  inherit (lib) runTests;
  mylib = import ./default.nix { inherit lib builtins; };
in {
  testRemoveHash = {
    expr = mylib.removeHash "#abcdef";
    expected = "abcdef";
  };
  
  testScanPaths = {
    expr = mylib.scanPaths ../modules/shared/nix-user-pkgs;
    expected = [
      ../modules/shared/nix-user-pkgs/devtunnel-cli
      ../modules/shared/nix-user-pkgs/home.nix
    ];
  };
  
  testExtractName = {
    expr = mylib.extractName "../modules/shared/nix-user-pkgs/devtunnel-cli/default.nix";
    expected = "default";
  };
  
  testIfLet = {
    expr = mylib.if_let { a = 1; b = 2; } { a = 1; };
    expected = { a = 1; b = 2; };
  };
  
  testIfLetNoMatch = {
    expr = mylib.if_let { a = 2; } { a = 1; };
    expected = null;
  };
  
  testMatch = {
    expr = mylib.match { type = "success"; value = 42; } [
      [{ type = "error"; } "error"]
      [{ type = "success"; } "success"]
    ];
    expected = "success";
  };
  
  testImportAll = {
    expr = builtins.length (mylib.importAll [ ./default.nix ]);
    expected = 1;
  };
  
  testRemoveSuffix = {
    expr = mylib.removeSuffix ".nix" "test.nix";
    expected = "test";
  };
  
  testRemoveSuffixNoMatch = {
    expr = mylib.removeSuffix ".txt" "test.nix";
    expected = "test.nix";
  };
  
  testRelativeToRoot = {
    expr = mylib.relativeToRoot "modules";
    expected = ../modules;
  };
}
