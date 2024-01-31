let
  aliases = (import ./aliases.nix);
in {
  programs.bash = {
    enable = true;
    shellAliases = aliases;
  };
}
