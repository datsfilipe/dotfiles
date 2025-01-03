set fish_greeting ""

set -g fish_vi_force_cursor 1
set fish_cursor_default block blink
set fish_cursor_insert block blink
set fish_cursor_replace_one block blink
set fish_cursor_external block blink
set fish_cursor_visual block blink

function fish_mode_prompt; end
set -x fish_key_bindings fish_vi_key_bindings
set -g hydro_symbol_prompt "💀"

set -gx ZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --color=always"
set -gx ZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
zoxide init fish | source
set -gx zoxide_cmd z
