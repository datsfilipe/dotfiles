{mypkgs, ...}: let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij.enable = true;
  modules.desktop.conf.zellij = {
    content = builtins.readFile ./conf/config.kdl;
    layoutContent = builtins.readFile ./conf/layout.kdl;
  };

  home.shellAliases = shellAliases;
  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";
  };

  modules.desktop.nupkgs.packages = with mypkgs; [
    zellij-switch
  ];
}
