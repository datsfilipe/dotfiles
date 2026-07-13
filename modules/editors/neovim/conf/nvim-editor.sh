exec nvim --clean \
  -c 'set clipboard=unnamedplus' \
  -c 'highlight Normal guibg=NONE ctermbg=NONE' \
  "$@"
