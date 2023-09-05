export ZSH="$HOME/.oh-my-zsh"
# git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
# ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
ZSH_THEME="spaceship"

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
# git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-z
  auto-notify
)

source ~/.zsh_spaceship
source $ZSH/oh-my-zsh.sh # https://ohmyz.sh/
# zsh-autosuggestions config
bindkey '^ ' autosuggest-accept

source ~/.zsh_aliases
source ~/.zsh_exports
