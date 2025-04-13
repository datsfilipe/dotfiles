{
  pkgs,
  mypkgs,
  zellij-switch,
  config,
  lib,
  ...
}: let
  shellAliases = {
    "zj" = "zellij";
  };

  scriptpath = script: "${config.home.homeDirectory}/.local/bin/${script}";
  pluginpath = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";

  replacer = script: text:
    lib.replaceStrings ["Run \"${script}\""] [
      "Run \"${scriptpath script}\" \"--plugin\" \"${pluginpath}\""
    ]
    text;

  scrollback-editor = pkgs.writeShellScriptBin "zellij-scrollback-editor" ''
    #!/bin/bash
    nvim --clean -c "set clipboard=unnamedplus" -c "highlight Normal guibg=NONE ctermbg=NONE" "$@"
  '';
in {
  programs.zellij.enable = true;
  modules.desktop.conf.zellij = {
    content =
      replacer "zellij-session-nav"
      (replacer "zellij-sessionizer"
        (builtins.readFile ./conf/config.kdl));
    layoutContent = builtins.readFile ./conf/layout.kdl;
  };

  home.shellAliases = shellAliases;
  home.sessionVariables = {
    ZELLIJ_SWITCH_PATH = "${mypkgs.zellij-switch}/bin/zellij-switch.wasm";
    FZF_DEFAULT_OPTS = "--color bg:-1,bg+:-1,fg:#CCCCCC,fg+:#CCCCCC,header:#A0A0A0,hl:#A0A0A0,hl+:#A0A0A0,info:#FFCFA8,marker:#FFCFA8,pointer:#FFCFA8,prompt:#FFCFA8,spinner:#FFCFA8
";
  };

  home.packages = with pkgs; [
    scrollback-editor
  ];

  modules.desktop.nupkgs.packages = with mypkgs; [
    zellij-switch
  ];
}
