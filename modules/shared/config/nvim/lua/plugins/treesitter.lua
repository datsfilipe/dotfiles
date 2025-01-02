return {
  'nvim-treesitter/nvim-treesitter',
  version = false,
  build = ':TSUpdate',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    ensure_installed = {
      'bash',
      'fish',
      'gitcommit',
      'graphql',
      'html',
      'json',
      'json5',
      'jsonc',
      'lua',
      'markdown',
      'markdown_inline',
      'regex',
      'scss',
      'toml',
      'tsx',
      'javascript',
      'typescript',
      'yaml',
    },
    highlight = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<cr>',
        node_incremental = '<cr>',
        scope_incremental = false,
        node_decremental = '<bs>',
      },
    },
    indent = {
      enable = true,
      -- Treesitter unindents Yaml lists for some reason.
      disable = { 'yaml' },
    },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
