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

# spaceship prompt config
SPACESHIP_PROMPT_ORDER=(
  user
  dir
  host
  git
  hg
  exec_time
  jobs
  line_sep
  exit_code
  char
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯ "

source $ZSH/oh-my-zsh.sh # https://ohmyz.sh/

# zsh-autosuggestions config
bindkey '^ ' autosuggest-accept

# aliases
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
# tmux
alias t=tmux
alias ta="tmux attach"
alias ts="tmux new-session -s"
alias tl="tmux ls"
alias tk="tmux kill-session -t"

function rm() {
  echo "Use trash instead of rm"
}

# create and enter dir
function dir() {
  mkdir $1 && cd $1
}

# git
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

# change dir
function change_dir() {
  builtin cd $(nav)
}
zle -N change_dir
bindkey '^F' change_dir

# exports
export TERMINAL=alacritty
export EDITOR=nvim
export PATH=bin:$PATH
export PATH=~/bin:$PATH
export PATH=~/.local/bin:$PATH
# fzf with fd
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --color=always"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
# asdf
. /opt/asdf-vm/asdf.sh
export PATH=~/.asdf/shims:$PATH
# pnpm
export PNPM_HOME="/home/dtsf/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
export PATH=$PATH:/home/dtsf/.spicetify
