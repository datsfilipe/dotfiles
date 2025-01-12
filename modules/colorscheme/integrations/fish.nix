{
  config,
  lib,
  colorscheme,
  ...
}: let
  hydroConfig = config.xdg.configFile."fish/conf.d/hydro.fish".text or null;
in {
  xdg.configFile."fish/conf.d/colorscheme.fish".text = ''
    set -g fish_color_normal "${colorscheme.colors.blue}"
    set -g fish_color_command "${colorscheme.colors.yellow}"
    set -g fish_color_quote "${colorscheme.colors.blue}"
    set -g fish_color_redirection "${colorscheme.colors.magenta}"
    set -g fish_color_end "${colorscheme.colors.magenta}"
    set -g fish_color_error "${colorscheme.colors.red}"
    set -g fish_color_escape "${colorscheme.colors.red}"
    set -g fish_color_cwd "${colorscheme.colors.blue}"
    set -g fish_color_cwd_root "${colorscheme.colors.red}"
    set -g fish_color_match "${colorscheme.colors.red}"
    set -g fish_color_selection "${colorscheme.colors.black}"
    set -g fish_color_search_match "${colorscheme.colors.magenta}"
    set -g fish_color_operator "${colorscheme.colors.cyan}"
    set -g fish_color_param "${colorscheme.colors.fg}"
    set -g fish_color_comment "${colorscheme.colors.black}"
    set -g fish_color_history_current "${colorscheme.colors.blue}"
    set -g fish_color_host "${colorscheme.colors.blue}"
    set -g fish_color_autosuggestion "${colorscheme.colors.fg}"
    set -g fish_color_valid_path "${colorscheme.colors.green}"
    set -g fish_color_user "${colorscheme.colors.yellow}"

    set -g fish_pager_color_progress "${colorscheme.colors.blue}"
    set -g fish_pager_color_prefix "${colorscheme.colors.blue}"
    set -g fish_pager_color_description "${colorscheme.colors.blue}"
    set -g fish_pager_color_completion "${colorscheme.colors.blue}"

    ${lib.optionalString (hydroConfig != null) ''
      set -g hydro_color_prompt "${colorscheme.colors.primary}"
        set -g hydro_color_pwd "${colorscheme.colors.primary}"
        set -g hydro_color_git "${colorscheme.colors.magenta}"
        set -g hydro_color_error "${colorscheme.colors.red}"
        set -g hydro_color_duration "${colorscheme.colors.green}"
    ''}
  '';
}
