let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij.enable = true;

  xdg.configFile."zellij/config.kdl".source = ./conf/config.kdl;
  xdg.configFile."zellij/layouts/default.kdl".source = ./conf/layout.kdl;

  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = builtins.toString ./conf/zellij-switch.wasm;
  };

  home.shellAliases = shellAliases;
}
