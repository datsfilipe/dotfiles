{ pkgs, lib, theme, vars, ... }:

with lib; let
  statusLeft = "#[fg=${theme.scheme.colors.fg},bg=${theme.scheme.colors.bg}] #S ";
  statusRight = "#[fg=${theme.scheme.colors.primary},bg=${theme.scheme.colors.bg}] @#(whoami) ";
in
mkIf (vars.environment.multiplexer == "tmux") {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    escapeTime = 10;
    keyMode = "vi";
    mouse = false;
    shell = "${vars.environment.shell}";
    historyLimit = 64096;
    extraConfig = ''
      ${fileContents ../../../dotfiles/tmux.conf}

      # THEME
      set -g status-bg "${theme.scheme.colors.bg}"
      set -g status-fg "${theme.scheme.colors.primary}"

      set -g status-left "${statusLeft}"
      set -g status-right "${statusRight}"

      set -g pane-border-style "fg=${theme.tmux-border-color}"
      set -g pane-active-border-style "fg=${theme.tmux-border-color}"
    '';

    tmuxinator.enable = true;
  };
}
