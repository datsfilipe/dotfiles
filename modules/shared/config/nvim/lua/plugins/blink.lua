return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  version = '*',
  opts = {
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      ['/'] = { 'hide', 'fallback' },
      ['<C-n>'] = { 'select_next', 'show' },
      ['<Tab>'] = { 'select_next', 'fallback' },
      ['<C-p>'] = { 'select_prev' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
      list = {
        selection = 'auto_insert',
        max_items = 10,
      },
      menu = {
        border = 'none',
      },
      documentation = {
        auto_show = true,
        window = { border = 'none' },
      },
    },
    sources = {
      cmdline = {},
    },
    appearance = {
      kind_icons = require('icons').symbol_kinds,
    },
  },
}
