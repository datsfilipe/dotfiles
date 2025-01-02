local options = { noremap = true, silent = true }

vim.keymap.set(
  'i',
  '<C-c>',
  '<Esc>',
  vim.tbl_extend('force', options, { desc = 'curse' })
)

vim.keymap.set(
  'n',
  '<leader><leader>',
  '<cmd>so<cr>',
  vim.tbl_extend('force', options, { desc = 'no walking on space' })
)

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'scroll downwards' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'previous result' })

vim.keymap.set(
  'v',
  '<',
  '<gv',
  vim.tbl_extend('force', options, { desc = 'indent left' })
)
vim.keymap.set(
  'v',
  '>',
  '>gv',
  vim.tbl_extend('force', options, { desc = 'indent right' })
)
vim.keymap.set(
  'n',
  '<A-z>',
  ':set wrap!<Return>',
  vim.tbl_extend('force', options, { desc = 'toggle wrap' })
)

vim.keymap.set(
  'v',
  'J',
  ":m '>+1<Return>gv=gv",
  vim.tbl_extend('force', options, { desc = 'move lines down' })
)
vim.keymap.set(
  'v',
  'K',
  ":m '<-2<Return>gv=gv",
  vim.tbl_extend('force', options, { desc = 'move lines up' })
)
vim.keymap.set(
  'n',
  '<leader>j',
  ':m .+1<Return>==',
  vim.tbl_extend('force', options, { desc = 'move line down' })
)
vim.keymap.set(
  'n',
  '<leader>k',
  ':m .-2<Return>==',
  vim.tbl_extend('force', options, { desc = 'move line down' })
)

vim.keymap.set('n', '<leader>]', ':split<Return>', options)
vim.keymap.set('n', '<leader>[', ':vsplit<Return>', options)
vim.keymap.set('n', '<leader>-', '<C-w>_<C-w><Bar>', options)
vim.keymap.set('n', '<leader>=', '<C-w>=', options)

vim.keymap.set('n', '<leader>t', ':tabnew<Return>', options)
vim.keymap.set('n', '>', ':tabnext<Return>', options)
vim.keymap.set('n', '<', ':tabprev<Return>', options)

vim.keymap.set('n', '<leader>Y', 'ggVG"+y', options)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], options)
vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]], options)
vim.keymap.set('x', '<leader>p', [["_dP]], options)
