{ pkgs, lib, ... }:

let
  theme = (import ../../modules/colorscheme).theme;
  aliases = (import ./aliases.nix);
in {
  programs.fish = {
    enable = true;
    shellAliases = aliases;

    functions = {
      fish_user_key_bindings = ''
        bind --preset -M insert \cl 'clear; commandline -f repaint'
        bind --preset -M insert \cf zellij-sessionizer
        bind --preset -M insert -k nul accept-autosuggestion
      '';
      ts = ''
        tmux new-session -d -s $argv[1]
        tmux switch-client -t $argv[1]
      '';
      v = ''
        cd ~/.config/datsvault
        tmux new-session -d -s vault
        tmux switch-client -t vault
      '';
      dtc = ''
        devtunnel create $argv[1]
        devtunnel port create $argv[1] -p $argv[2]
        devtunnel access create $argv[1] -p $argv[2] --anonymous
        devtunnel host $argv[1]
      '';
    };

    shellInit = ''
      source ~/.config/fish/conf.d/colorscheme.fish

      ${lib.fileContents ../../dotfiles/fish/config.fish}

      set -gx ZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --color=always"
      set -gx ZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND

      # plugins
      zoxide init fish | source
      set -gx zoxide_cmd z
    '';
  };

  # plugins
  home.packages = with pkgs; [
    fishPlugins.hydro
    fishPlugins.done
  ];

  xdg.configFile."fish/conf.d/hydro.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.hydro}/share/fish

    ${lib.fileContents ../../dotfiles/fish/conf.d/hydro.fish}
  '';

  xdg.configFile."fish/conf.d/done.fish".text = ''
    set -l plugin_dir ${pkgs.fishPlugins.done}/share/fish

    ${lib.fileContents ../../dotfiles/fish/conf.d/done.fish}
  '';

  # tmuxinator completions
  xdg.configFile."fish/completions/tmuxinator.fish".text = ''
    source ${pkgs.tmuxinator}/share/fish/vendor_completions.d/tmuxinator.fish
  '';

  # colorscheme
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

    # hydro colors
    set -g hydro_color_prompt "${theme.scheme.colors.primary}"
    set -g hydro_color_pwd "${theme.scheme.colors.primary}"
    set -g hydro_color_git "${theme.scheme.colors.magenta}" 
    set -g hydro_color_error "${theme.scheme.colors.red}" 
    set -g hydro_color_duration "${theme.scheme.colors.green}" 
  '';
}
