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
      ext = url: {
        inherit url;
        inputs.nixpkgs.follows = "nixpkgs";
      };
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
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
      linux-shimeji = ext "github:datsfilipe/linux-shimeji/main";
      zellij-switch = ext "github:datsfilipe/zellij-switch/flake";
      home-manager = ext "github:nix-community/home-manager/master";
      sops-nix = ext "github:Mic92/sops-nix/master";
      neovim-nightly = ext "github:nix-community/neovim-nightly-overlay/master";
      astal = ext "github:aylur/astal/main";
      datsnvim = ext-hm "github:datsfilipe/datsnvim/main";
      unix-scripts = local ../modules/home/linux/base/scripts/conf;
    };
    outputs = "inputs: import ./outputs inputs";
  }
