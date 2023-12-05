{ pkgs, lib, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
  statusLeft = "#[fg=${theme.scheme.colors.fg},bg=${theme.scheme.colors.bg}] #S ";
  statusRight = "#[fg=${theme.scheme.colors.red},bg=${theme.scheme.colors.bg}] @#(whoami) ";
in {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    escapeTime = 10;
    keyMode = "vi";
    mouse = false;
    shell = "${pkgs.zsh}/bin/zsh";
    historyLimit = 64096;
    extraConfig = ''
      ${lib.fileContents ../../dotfiles/tmux.conf}

      # THEME
      set -g status-bg "${theme.scheme.colors.bg}"
      set -g status-fg "${theme.scheme.colors.red}"

      set -g status-left "${statusLeft}"
      set -g status-right "${statusRight}"

      set -g pane-border-style "fg=${theme.scheme.colors.red}"
      set -g pane-active-border-style "fg=${theme.scheme.colors.red}"
    '';
  };
}
