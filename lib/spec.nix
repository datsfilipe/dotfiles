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
    expr = mylib.scanPaths ../modules/nupkgs;
    expected = [
      ../modules/nupkgs/devtunnel-cli
      ../modules/nupkgs/home.nix
    ];
  };
  
  testExtractName = {
    expr = mylib.extractName "../modules/nupkgs/devtunnel-cli/default.nix";
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

  testMapLookup = {
    expr = mylib.mapLookup { value = "min"; } {
      min = {
        theme = {
          name = "test";
          package = {};
        };
        iconTheme = {
          name = "test";
          package = {};
        };
      };
      gruvbox = {
        theme = {
          name = "test1";
          package = {};
        };
        iconTheme = {
          name = "test1";
          package = {};
        };
      };
    };
    expected = {
      theme = {
        name = "test";
        package = {};
      };
      iconTheme = {
        name = "test";
        package = {};
      };
    };
  };
}