let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  imports = [
    ./config.nix
  ];

  programs.zellij.enable = true;
  modules.desktop.zellij.config = {
    enable = true;
    content = builtins.readFile ./conf/config.kdl;
    layoutContent = builtins.readFile ./conf/layout.kdl;
  };

  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = builtins.toString ./conf/zellij-switch.wasm;
  };

  home.shellAliases = shellAliases;
}
