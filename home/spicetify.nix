{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  programs.spicetify =
  let
    officialThemesOLD = pkgs.fetchgit {
      url = "https://github.com/spicetify/spicetify-themes";
      rev = "c2751b48ff9693867193fe65695a585e3c2e2133";
      sha256 = "0rbqaxvyfz2vvv3iqik5rpsa3aics5a7232167rmyvv54m475agk";
    };
  in {
    enable = true;
    theme = {
      name = "text";
      src = officialThemesOLD;
      patches = {
        "xpui.js_find_8008" = ",(\\w+=)56";
        "xpui.js_repl_8008" = ",$\{1}32";
      };
      injectCss = true;
      replaceColors = true;
      appendName = true;
      overwriteAssets = false;
      sidebarConfig = false;
    };
    colorScheme = "spotify";

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      hidePodcasts
      adblock
    ];
  };
}
