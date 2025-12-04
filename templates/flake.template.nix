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
      ext = url: with-nixpkgs:
        {
          inherit url;
        }
        // (
          if with-nixpkgs
          then {
            inputs.nixpkgs.follows = "nixpkgs";
          }
          else {}
        );

      ext-unstable = url: let
        base = {inherit url;};
      in
        base // {inputs = {nixpkgs.follows = "nixpkgs-unstable";};};

      ext-hm = url: {
        inherit url;
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "home-manager";
      };

      local = path: {
        url = "git+file://${toString path}?shallow=1";
        flake = false;
      };
    in {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
      ghostty = ext "github:ghostty-org/ghostty/main" false;
      linux-shimeji = ext "github:datsfilipe/linux-shimeji/main" true;
      zellij-switch = ext "github:datsfilipe/zellij-switch/flake" true;
      home-manager = ext "github:nix-community/home-manager/master" true;
      sops-nix = ext "github:Mic92/sops-nix/master" true;
      meow = ext-unstable "github:datsfilipe/meow/main";
      datsnvim = ext-hm "github:datsfilipe/datsnvim/main";
      unix-scripts = local ../pkgs/scripts/conf;
    };
    outputs = "inputs: import ./outputs inputs";
  }
