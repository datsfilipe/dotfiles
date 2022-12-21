# Set fish greeting
set fish_greeting ""

# Set terminal color scheme
set -g theme_color_scheme terminal-dark

# Ban the rm command
function rm
  echo "don't use rm, use del instead"
end

# Set prompt symbols
set hydro_symbol_prompt ""
set hydro_symbol_git_dirty " "
set hydro_symbol_git_ahead ""
set hydro_symbol_git_behind ""

# Set aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias cat bat
alias remove-lock "rm /var/lib/pacman/db.lck"
alias play-playlist "mpv --shuffle --really-quiet --loop-playlist yes --no-video"
alias download-youtube-playlist "youtube-dl -i -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --yes-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'"
alias download-youtube-music "youtube-dl -i -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --no-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'"
alias download-youtube-video "youtube-dl -i -f bestvideo --format mp4 --no-playlist --embed-thumbnail --add-metadata --output '%(title)s.%(ext)s'"
alias del "trash-put"
alias delc "trash-empty"
alias dell "trash-list"
alias delu "trash-restore"
alias delr "trash-rm"

# Use Neovim if it is installed
if command -qv nvim
  alias vim nvim
end

# Configure asdf plugin manager
source /opt/asdf-vm/asdf.fish

# Set Neovim as the editor
set -gx EDITOR nvim
set -gx TERMINAL alacritty

# Add bin directories to $PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Set exa as the ls replacement if it is installed
if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# Load local configuration file
set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
  source $LOCAL_CONFIG
end

# Set config variables
set -gx WALLPAPER 06

# Load theme configuration
source ~/.config/fish/theme.conf

# Tmux default theme
tmux source-file "$HOME/.config/tmux/themes/$THEME.conf"

# Load fish theme configuration
set current_theme $THEME
source (dirname (status --current-filename))/conf.d/$current_theme.fish

# Configure pnpm
set -gx PNPM_HOME "/home/dtsf/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
