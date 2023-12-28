{ config, pkgs, lib, ... }:

let
  aliases = {
    "cat" = "bat";
    "ll"="eza -l -g --icons";
    "lla"="eza -l -a -g --icons";
    "tree"="eza --tree";
    "del"="trash-put";
    "dels"="trash-list";
    "delu"="trash-restore";
    "delc"="trash-empty";
    "delr"="trash-rm";
    "t"="tmux";
    "ta"="tmux attach";
    "rm" = "echo \"Use trash instead of rm\"";
    "g"="git";
    "ga"="git add";
    "gc"="git commit";
    "gca"="git commit --amend";
    "root"="cd \"$(git rev-parse --show-toplevel)\"";
    "main"="git checkout main";
    "nsh"="nix-set-shell";
    "cr"="curl-request";
    "wconn"="nmcli-wifi-connect";
    "td"="taskwarrior-tui";
    "vl"="datsvault -l";
    "vn"="datsvault -n";
    "vd"="datsvault -d";
    "vs"="datsvault -s";
    "vu"="datsvault -u";
  };
in
{ 
  programs = {
    zsh = {
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

    bash = {
      enable = true;
      shellAliases = aliases;
    };
  };

  home = { packages = with pkgs; [ bat eza zoxide trash-cli ]; };
}
