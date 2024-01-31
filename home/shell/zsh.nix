{ config, pkgs, lib, ... }:

let
  aliases = (import ./aliases.nix);
in
{ 
  home.packages = with pkgs; [ zoxide ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      ${lib.fileContents ../../dotfiles/zshrc}
    '';
    shellAliases = aliases;

    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };

    plugins = [
      {
        name = "spaceship";
        src = pkgs.spaceship-prompt;
        file = "share/zsh/themes/spaceship.zsh-theme";
      }
    ];
  };

  xdg.configFile."spaceship.zsh".source = ../../dotfiles/spaceship.zsh;
}
