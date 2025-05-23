{pkgs ? import <nixpkgs> {}}: let
  inherit (pkgs) lib;
  mylib = import ./default.nix {inherit lib builtins;};
in {
  testRemoveHash = {
    expr = mylib.removeHash "#abcdef";
    expected = "abcdef";
  };

  testScanPaths = {
    expr = mylib.file.scanPaths ../outputs;
    expected = [
      ../outputs/x86_64-linux
    ];
  };

  testExtractName = {
    expr = mylib.extractName "../modules/nupkgs/devtunnel-cli/default.nix";
    expected = "default";
  };

  testIfLet = {
    expr =
      mylib.if_let
      {
        a = 1;
        b = 2;
      }
      {a = 1;};
    expected = {
      a = 1;
      b = 2;
    };
  };

  testIfLetNoMatch = {
    expr =
      mylib.if_let
      {a = 2;}
      {a = 1;};
    expected = null;
  };

  testMatch = {
    expr =
      mylib.match
      {
        type = "success";
        value = 42;
      }
      [
        [{type = "error";} "error"]
        [{type = "success";} "success"]
      ];
    expected = "success";
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
    expr = mylib.file.relativeToRoot "modules";
    expected = ../modules;
  };

  testMapLookup = {
    expr =
      mylib.mapLookup
      {value = "min";}
      {
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

  testFormatSections = {
    expr =
      mylib.format.sections
      ["a" "b"]
      {
        a = {
          a = "1";
          b = "2";
        };
        b = {
          a = "3";
          b = "4";
        };
      };
    expected = ''
      [a]
      a="1"
      b="2"


      [b]
      a="3"
      b="4"

    '';
  };

  testFormatSectionsNoCategories = {
    expr =
      mylib.format.sections
      []
      {
        a = "1";
        b = [
          "name = 'Notification'"
          "class_g ?= 'Notify-osd'"
          "class_g = 'Polybar'"
          "class_g = 'Rofi'"
          "window_type = 'tooltip'"
        ];
        c = 3;
        d = "4";
        e = ["5" "6"];
        f = true;
      };
    expected = ''
      a="1"
      b=[
        "name = 'Notification'",
        "class_g ?= 'Notify-osd'",
        "class_g = 'Polybar'",
        "class_g = 'Rofi'",
        "window_type = 'tooltip'",
      ]
      c=3
      d="4"
      e=[
        "5",
        "6",
      ]
      f=true
    '';
  };

  testDarkenHex = {
    expr = mylib.color.darkenHex "#C0C0C0" 0.5;
    expected = "#606060";
  };
}
