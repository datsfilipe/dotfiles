function fish_user_key_bindings
  bind \cl 'clear; commandline -f repaint'

  # peco
  bind \cr peco_select_history # Bind for peco select history to Ctrl+R
  bind \cf peco_change_directory # Bind for peco change directory to Ctrl+F
end
