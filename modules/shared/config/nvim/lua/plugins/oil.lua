return {
  'stevearc/oil.nvim',
  lazy = false,
  keys = {
    { '<leader>e', '<cmd>Oil<cr>' },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ['<leader>v'] = 'actions.select_split',
    },
    view_options = {
      show_hidden = true,
    },
    columns = {
      'mtime',
    },
  },
}
