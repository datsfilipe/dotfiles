return {
  'mfussenegger/nvim-lint',
  event = 'BufWritePost',
  config = function()
    local utils = require 'utils'

    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function()
        if utils.is_bin_available 'codespell' then
          require('lint').try_lint 'codespell'
        end
      end,
    })
  end,
}
