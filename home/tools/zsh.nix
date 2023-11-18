{ config, pkgs, ... }:

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
    "lm"="list-manager";
    "nsh"="nix-set-shell";
    "cr"="curl-request";
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
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        bindkey '^ ' autosuggest-accept

        # spaceship theme
        ZSH_THEME="spaceship"
        SPACESHIP_PROMPT_ORDER=(
          user
          dir
          host
          git
          hg
          exec_time
          jobs
          line_sep
          exit_code
          char
        )
        SPACESHIP_USER_SHOW=always
        SPACESHIP_PROMPT_ADD_NEWLINE=false
        SPACESHIP_CHAR_SYMBOL="❯ "

        # tmux
        function ts() {
          tmux new-session -d -s $1
          tmux switch-client -t $1
        }
        function tmux-sessionizer() {
          bash -c "~/.local/bin/tmux-sessionizer"
        }
        zle -N tmux-sessionizer
        bindkey '^F' tmux-sessionizer

        function list-manager-fzf() {
          bash -c "~/.local/bin/lm-fzf"
        }
        zle -N list-manager-fzf
        bindkey '^T' list-manager-fzf

        # utils
        function rm() {
          echo "Use trash instead of rm"
        }
        function dir() {
          mkdir $1 && cd $1
        }
        function pr() {
          if [ $1 = "ls" ]; then
            gh pr list
          else
            gh pr checkout $1
          fi
        }

        export WAKATIME_HOME="$HOME/.config"
        export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --color=always"
        export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
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
