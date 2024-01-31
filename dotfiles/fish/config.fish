set fish_greeting ""

# cursor
set -g fish_vi_force_cursor 1
set fish_cursor_default block blink
set fish_cursor_insert block blink
set fish_cursor_replace_one block blink
set fish_cursor_external block blink
set fish_cursor_visual block blink

# vi mode
function fish_mode_prompt; end
set -x fish_key_bindings fish_vi_key_bindings
