{ mylib, name, pkgs, ...}:

let
  themes = {
    gruvbox = {
      theme = {
        name = "Flat-Remix-GTK-Yellow-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-dark";
        package = pkgs.reversal-icon-theme;
      };
    };
    min = {
      theme = {
        name = "Flat-Remix-GTK-Red-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-red-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = [ "-red" ];
        };
      };
    };
    solarized = {
      theme = {
        name = "Flat-Remix-GTK-Cyan-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-cyan-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = [ "-cyan" ];
        };
      };
    };
    vesper = {
      theme = {
        name = "Flat-Remix-GTK-Grey-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-black-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = [ "-black" ];
        };
      };
    };
    catppuccin = {
      theme = {
        name = "Flat-Remix-GTK-Magenta-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-purple-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = [ "-purple" ];
        };
      };
    };
    kanagawa = {
      theme = {
        name = "Flat-Remix-GTK-Orange-Darkest-Solid";
        package = pkgs.flat-remix-gtk;
      };
      iconTheme = {
        name = "Reversal-orange-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = [ "-orange" ];
        };
      };
    };
  };
in
  mylib.mapLookup { value = name; } themes
