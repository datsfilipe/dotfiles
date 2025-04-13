{
  pkgs,
  lib,
  path,
  ...
}:
with lib; {
  programs.fish = {
    enable = true;
    functions = {
      fish_user_key_bindings = ''
        bind --preset -M insert \cl 'clear; commandline -f repaint'
        bind --preset -M insert \a accept-autosuggestion
      '';
    };

    shellInit = ''
      export ${path}
    '';
  };
}
