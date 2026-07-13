nvim --clean \
  -c "set relativenumber" \
  -c "lua vim.g.clipboard = { name = 'smart-clipboard', copy = { ['+'] = 'shared-clipboard copy' }, paste = { ['+'] = 'shared-clipboard paste' }, cache_enabled = 0 }" \
  -c "set clipboard+=unnamedplus" \
  -c "highlight Normal guibg=NONE ctermbg=NONE" \
  + "$@"
