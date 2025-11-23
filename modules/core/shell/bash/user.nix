{myvars, ...}: let
in {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export ${myvars.path}
    '';
  };
}
