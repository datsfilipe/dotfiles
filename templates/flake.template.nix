with builtins; let
  topretty = import ../scripts/topretty.nix;
  genFlake = thisFile: attrs: let
    standardizedAttrs =
      attrs
      // {
        outputs = "<outputs>";
      };
    flakeContent = topretty "" standardizedAttrs;
  in
    attrs
    // {
      flake =
        replaceStrings
        ["\"<outputs>\""]
        [attrs.outputs]
        flakeContent;
    };
in
  genFlake ./flake.template.nix
  {
    description = "datsdots";
    inputs = let
      mkInput = url: args:
        {inherit url;}
        // (
          if isList args
          then
            (
              if args == []
              then {}
              else {
                inputs = listToAttrs (map (name: {
                    inherit name;
                    value = {follows = name;};
                  })
                  args);
              }
            )
          else args
        );

      local = path: mkInput "git+file://${toString path}?shallow=1" {flake = false;};
    in {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
      linux-shimeji = mkInput "github:datsfilipe/linux-shimeji/main" ["nixpkgs"];
      zellij-switch = mkInput "github:datsfilipe/zellij-switch/flake" ["nixpkgs"];
      home-manager = mkInput "github:nix-community/home-manager/master" ["nixpkgs"];
      sops-nix = mkInput "github:Mic92/sops-nix/master" ["nixpkgs"];
      astal = mkInput "github:aylur/astal/7d1fac8a4b2a14954843a978d2ddde86168c75ef" ["nixpkgs"];
      datsnvim = mkInput "github:datsfilipe/datsnvim/main" ["nixpkgs" "home-manager"];
      ags = mkInput "github:aylur/ags/e169694390548dfd38ff40f1ef2163d6c3ffe3ea" ["nixpkgs" "astal"];
      meow = mkInput "github:datsfilipe/meow/main" {inputs.nixpkgs.follows = "nixpkgs-unstable";};
      unix-scripts = local ../pkgs/scripts/conf;
    };
    outputs = "inputs: import ./outputs inputs";
  }
