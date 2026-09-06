{
  mylib,
  name,
  pkgs,
  ...
}: let
  gtkThemePackage = pkgs.catppuccin-gtk.override {
    accents = ["yellow" "red" "teal" "lavender" "blue" "mauve"];
    size = "standard";
    tweaks = ["black"];
    variant = "mocha";
  };

  themes = {
    gruvbox = {
      theme = {
        name = "catppuccin-mocha-yellow-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-dark";
        package = pkgs.reversal-icon-theme;
      };
    };
    min = {
      theme = {
        name = "catppuccin-mocha-red-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-red-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = ["red"];
        };
      };
    };
    solarized = {
      theme = {
        name = "catppuccin-mocha-teal-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-cyan-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = ["cyan"];
        };
      };
    };
    vesper = {
      theme = {
        name = "catppuccin-mocha-lavender-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-black-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = ["black"];
        };
      };
    };
    carbon = {
      theme = {
        name = "catppuccin-mocha-blue-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-blue-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = ["blue"];
        };
      };
    };
    catppuccin = {
      theme = {
        name = "catppuccin-mocha-mauve-standard+black";
        package = gtkThemePackage;
      };
      iconTheme = {
        name = "Reversal-purple-dark";
        package = pkgs.reversal-icon-theme.override {
          colorVariants = ["purple"];
        };
      };
    };
  };
in
  mylib.mapLookup {value = name;} themes
