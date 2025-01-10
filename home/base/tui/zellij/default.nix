{mypkgs, zellij-switch, config, lib, ...}: let
  shellAliases = {
    "zj" = "zellij";
  };

  scriptpath = script: "${config.home.homeDirectory}/.local/bin/${script}";
  pluginpath = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";

  replacer = script: text: lib.replaceStrings ["Run \"${script}\""] [
    "Run \"${scriptpath script}\" \"--plugin\" \"${pluginpath}\""
  ] text;
in {
  programs.zellij.enable = true;
  modules.desktop.conf.zellij = {
    content =
      (replacer "zellij-session-nav"
        (replacer "zellij-sessionizer"
          (builtins.readFile ./conf/config.kdl)));
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
