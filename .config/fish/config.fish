# ------------------------------------------------------------------------------
# fish shell config
# ------------------------------------------------------------------------------
set fish_greeting ""
set -gx TERM xterm-256color
set -g theme_color_scheme terminal-dark

# bind CTRL + L to clear term
function fish_user_key_bindings
    bind \cl 'clear; commandline -f repaint'
end

# ban rm command
function "rm"
  echo "don't use rm, use del instead"
end

# set colorscheme gruvbox
set -U fish_color_normal "#282828"
set -U fish_color_command "#ebdbb2"
set -U fish_color_quote "#ebdbb2"
set -U fish_color_redirection "#ebdbb2"
set -U fish_color_end "#ebdbb2"
set -U fish_color_error "#fb4934"
set -U fish_color_escape "#fb4934"
set -U fish_color_cwd "#83a598"
set -U fish_color_cwd_root "#fb4934"
set -U fish_color_match "#fb4934"
set -U fish_color_selection "#282828"
set -U fish_color_search_match "#83a598"
set -U fish_color_operator "#83a598"
set -U fish_color_param "#83a598"
set -U fish_color_comment "#928374"
set -U fish_color_history_current "#ebdbb2"
set -U fish_color_host "#83a598"
set -U fish_color_autosuggestion "#83a598"
set -U fish_color_valid_path "#b8bb26"
set -U fish_color_user brgreen
set -U fish_color_cancel -r

# hydro prompt settings with gruvbox dark 
set hydro_color_prompt "#ebdbb2"
set hydro_color_pwd "#83a598"
set hydro_color_git "#83a598"
set hydro_color_error "#fb4934"
set hydro_color_duration "#b8bb26"

set hydro_symbol_prompt ""
set hydro_symbol_git_dirty " "
set hydro_symbol_git_ahead " "
set hydro_symbol_git_behind " "

# set aliases (cat --> bat, ls --> exa)
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias cat bat
alias remove-lock "rm /var/lib/pacman/db.lck"
alias play-playlist "mpv --shuffle --really-quiet --loop-playlist yes --no-video" # play playlists in mpv with shuffle and loop with one command
alias download-youtube-playlist "youtube-dl -i -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --yes-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'" 
alias download-youtube-music "youtube-dl -i -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --no-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'"
alias download-youtube-video "youtube-dl -i -f bestvideo --format mp4 --no-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'"
alias del "trash-put" # trash-put is a command line utility that moves files to the trash can
alias delc "trash-empty" # trash-empty is a command line utility that empties the trash can
alias dell "trash-list" # trash-list is a command line utility that lists the contents of the trash can
alias delu "trash-restore" # trash-restore is a command line utility that restores files from the trash can
alias delr "trash-rm" # trash-rm is a command line utility that removes files from the trash can
command -qv nvim && alias vim nvim

# config asdf plugin manager
source /opt/asdf-vm/asdf.fish

# set neovim as editor
set -gx EDITOR nvim
set -gx TERMINAL alacritty

# add bin dirs to $PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# set exa as ls replacement
if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# local config
set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

# pnpm
set -gx PNPM_HOME "/home/dtsf/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
