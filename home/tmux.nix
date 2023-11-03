{ pkgs, ... }:
let
  bg = "#1a1a1a";
  fg = "#d6656a";
  fgAlt = "#fafafa";
  statusLeft = "#[fg=${fgAlt},bg=${bg}] #S ";
  statusRight = "#[fg=${fg},bg=${bg}] @#(whoami) ";
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
      set -g default-terminal "tmux-256color"
      set-option -g repeat-time 0
      set-option -g focus-events on
      set-option -g status-justify "left"

      bind o run-shell "open #{pane_current_path}"
      bind -r e kill-pane -a
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

      # vim-like pane switching
      bind -r k select-pane -U 
      bind -r j select-pane -D 
      bind -r h select-pane -L 
      bind -r l select-pane -R 

      # resizing pane
      bind -r C-k resize-pane -U 5
      bind -r C-j resize-pane -D 5
      bind -r C-h resize-pane -L 5
      bind -r C-l resize-pane -R 5

      # allow the title bar to adapt to whatever host you connect to
      set -g set-titles on
      set -g set-titles-string "#T"

      # THEME
      set -g status-bg "${bg}"
      set -g status-fg "${fg}"

      set -g status-left "${statusLeft}"
      set -g status-right "${statusRight}"

      set -g pane-border-style "fg=${fg}"
      set -g pane-active-border-style "fg=${fg}"
    '';
  };
}
