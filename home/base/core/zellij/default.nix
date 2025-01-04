let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij.enable = true;
  home.shellAliases = shellAliases;
}
