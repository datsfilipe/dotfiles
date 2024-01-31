{ pkgs, lib, ... }:

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
    "top"="btop -p 1";
    "topp"="btop";
    "sg"="ast-grep";
    # scripts
    "nsh"="nix-set-shell";
    "cr"="curl-request";
    "wconn"="nmcli-wifi-connect";
    "vl"="datsvault -l";
    "vn"="datsvault -n";
    "vd"="datsvault -d";
    "vs"="datsvault -s";
    "vu"="datsvault -u";
  };
in {
  imports = [
    ./colorscheme.nix
    ./plugins.nix
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;

    functions = {
      fish_user_key_bindings = ''
        bind \cl 'clear; commandline -f repaint'
        bind \cf 'fish -c tmux-sessionizer'
      '';
    };

    shellInit = ''
      source ~/.config/fish/conf.d/colorscheme.fish

      ${lib.fileContents ../../../dotfiles/fish/config.fish}

      set -gx ZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --color=always"
      set -gx ZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    '';
  };
}
