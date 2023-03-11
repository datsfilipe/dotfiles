# Set fish greeting
set fish_greeting ""

# Load fish theme configuration
source ~/.config/fish/conf.d/gruvbox.fish

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
alias tvim "XDG_CONFIG_HOME=~/.test-config XDG_DATA_HOME=~/.test-config/data nvim" # second neovim configuration

# Use Neovim if it is installed
if command -qv nvim
  alias vim nvim
end

# Set Neovim as the editor
set -gx EDITOR nvim

# Set alacritty as the terminal
set -gx TERMINAL alacritty

# Configure asdf plugin manager
source /opt/asdf-vm/asdf.fish

# Set exa as the ls replacement if it is installed
if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# Add bin directories to $PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.asdf/shims $PATH

# Configure pnpm
set -gx PNPM_HOME "/home/dtsf/.local/share/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
