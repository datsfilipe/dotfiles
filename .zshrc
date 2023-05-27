export ZSH="$HOME/.oh-my-zsh"

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-z
)

source $ZSH/oh-my-zsh.sh # https://ohmyz.sh/

# zsh-autosuggestions config
bindkey '^ ' autosuggest-accept

# starship prompt
eval "$(starship init zsh)"

# override aliases
alias vim=nvim
alias cat=bat
# exa
alias ll="exa -l -g --icons"
alias lla="exa -l -a -g --icons"
# trash
alias del=trash-put
alias dels=trash-list
alias delu=trash-restore
alias delc=trash-empty
alias delr=trash-rm

function rm() {
  echo "Use trash instead of rm"
}

# create and enter dir
function dir() {
  mkdir $1 && cd $1
}

# Git
alias g=git
alias ga="git add"
alias gc="git commit"
alias gca="git commit --amend"
alias root='cd "$(git rev-parse --show-toplevel)"'
alias main='git checkout main'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

function pr() {
  if [ $1 = "ls" ]; then
    gh pr list
  else
    gh pr checkout $1
  fi
}

# globals
export TERMINAL=alacritty
export EDITOR=nvim

# asdf
. /opt/asdf-vm/asdf.sh
export PATH=~/.asdf/shims:$PATH

# pnpm
export PATH=/home/dtsf/.local/share/pnpm:$PATH

# bins bro
export PATH=bin:$PATH
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH

# fzf with fd
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --color=always"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND