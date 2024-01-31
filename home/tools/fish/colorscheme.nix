let
  theme = (import ../../../modules/colorscheme).theme;
in {
  xdg.configFile."fish/conf.d/colorscheme.fish".text = ''
    set -g fish_color_normal "${theme.scheme.colors.blue}"
    set -g fish_color_command "${theme.scheme.colors.yellow}"
    set -g fish_color_quote "${theme.scheme.colors.blue}"
    set -g fish_color_redirection "${theme.scheme.colors.magenta}"
    set -g fish_color_end "${theme.scheme.colors.magenta}"
    set -g fish_color_error "${theme.scheme.colors.red}"
    set -g fish_color_escape "${theme.scheme.colors.red}"
    set -g fish_color_cwd "${theme.scheme.colors.blue}"
    set -g fish_color_cwd_root "${theme.scheme.colors.red}"
    set -g fish_color_match "${theme.scheme.colors.red}"
    set -g fish_color_selection "${theme.scheme.colors.black}"
    set -g fish_color_search_match "${theme.scheme.colors.magenta}"
    set -g fish_color_operator "${theme.scheme.colors.cyan}"
    set -g fish_color_param "${theme.scheme.colors.fg}"
    set -g fish_color_comment "${theme.scheme.colors.black}"
    set -g fish_color_history_current "${theme.scheme.colors.blue}"
    set -g fish_color_host "${theme.scheme.colors.blue}"
    set -g fish_color_autosuggestion "${theme.scheme.colors.fg}"
    set -g fish_color_valid_path "${theme.scheme.colors.green}"
    set -g fish_color_user "${theme.scheme.colors.yellow}"

    # completion pager colors
    set -g fish_pager_color_progress "${theme.scheme.colors.blue}"
    set -g fish_pager_color_prefix "${theme.scheme.colors.blue}"
    set -g fish_pager_color_description "${theme.scheme.colors.blue}"
    set -g fish_pager_color_completion "${theme.scheme.colors.blue}"
  '';
}
