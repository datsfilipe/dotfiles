{ inputs, pkgs, ... }:

{
  imports = [ inputs.anyrun.homeManagerModules.default ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
      ];
      width = { fraction = 0.3; };
      hideIcons = true;
      ignoreExclusiveZones = false;
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = 5;
    };
    extraCss = ''
      .GtkWindow {
        width: fit;
      }
    '';
  };
}
