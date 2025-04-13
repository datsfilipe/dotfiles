{myvars, ...}: {
  home = {
    inherit (myvars) username;
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
