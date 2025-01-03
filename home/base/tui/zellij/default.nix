let
  shellAliases = {
    "zj" = "zellij";
  };
in {
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
  };

  home.shellAliases = shellAliases;
}
