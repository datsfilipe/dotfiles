{
  pkgs,
  mypkgs,
  myvars,
  zellij-switch,
  lib,
  ...
}: let
  shellAliases = {
    "zj" = "zellij";
  };

  scriptpath = script: "/etc/profiles/per-user/${myvars.username}/bin/${script}";
  pluginpath = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";

  replacer = script: text:
    lib.replaceStrings ["Run \"${script}\""] [
      "Run \"${scriptpath script}\" \"--plugin\" \"${pluginpath}\""
    ]
    text;

  pluginReplacer = text:
    lib.replaceStrings ["ZELLIJ_SWITCH_PLUGIN_PATH"] [pluginpath] text;

  scrollback-editor = pkgs.writeShellScriptBin "zellij-scrollback-editor" (builtins.readFile ./conf/zellij-scrollback-editor.sh);
in {
  programs.zellij.enable = true;
  modules.desktop.conf.zellij = {
    content =
      pluginReplacer
      (replacer "zellij-session-nav"
        (replacer "zellij-sessionizer"
          (builtins.readFile ./conf/config.kdl)));
    layoutContent = builtins.readFile ./conf/layout.kdl;
  };

  home.shellAliases = shellAliases;
  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";
  };

  home.packages = with pkgs; [
    scrollback-editor
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    zellij-switch
  ];
}
