ZSH_THEME="spaceship"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-z
  # auto-notify
)

source ~/.zsh_spaceship
source $ZSH/oh-my-zsh.sh # https://ohmyz.sh/
# zsh-autosuggestions config
bindkey '^ ' autosuggest-accept

source ~/.zsh_aliases
source ~/.zsh_exports

# bun completions
[ -s "/home/dtsf/.bun/_bun" ] && source "/home/dtsf/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
