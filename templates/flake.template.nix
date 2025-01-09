with builtins;
let 
  topretty = import ../scripts/topretty.nix;
  genFlake = thisFile: attrs:
    let
      standardizedAttrs = attrs // {
        outputs = "<outputs>";
      };
      flakeContent = topretty "" standardizedAttrs;
    in attrs // {
      flake = replaceStrings 
        [ "\"<outputs>\"" ] 
        [ attrs.outputs ]
        flakeContent;
    };
in genFlake ./flake.template.nix
{
  description = "description";
  inputs = let
    ext = url: { inherit url; inputs.nixpkgs.follows = "nixpkgs"; };
    local = path: { url = "git+file://${toString path}?shallow=1"; flake = false; };
  in {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = (ext "github:nix-community/home-manager/master");
    sops-nix = (ext "github:Mic92/sops-nix/master");
    datsnvim = (local ./home/base/tui/editors/neovim/conf);
    unix-scripts = (local ./home/linux/base/scripts/conf);
  };
  outputs = "inputs: import ./outputs inputs";
}
