{ pkgs, ... }:

let
  theme = (import ../modules/colorscheme).theme;
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
      set -g status-bg "${theme.scheme.colors.bg}"
      set -g status-fg "${theme.scheme.colors.fg}"

      set -g status-left "${statusLeft}"
      set -g status-right "${statusRight}"

      set -g pane-border-style "fg=${theme.scheme.colors.fg}"
      set -g pane-active-border-style "fg=${theme.scheme.colors.fg}"
    '';
  };
}
