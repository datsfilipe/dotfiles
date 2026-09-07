nvim --clean \
  -c "set relativenumber" \
  -c "set clipboard+=unnamedplus" \
  -c "highlight Normal guibg=NONE ctermbg=NONE" \
  + "$@"
