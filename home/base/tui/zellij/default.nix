let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij.enable = true;
  modules.desktop.conf.zellij = {
    content = builtins.readFile ./conf/config.kdl;
    layoutContent = builtins.readFile ./conf/layout.kdl;
  };

  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = builtins.toString ./conf/zellij-switch.wasm;
  };

  home.shellAliases = shellAliases;
}
