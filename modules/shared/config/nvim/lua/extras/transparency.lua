return {
  dir = vim.fn.stdpath 'config' .. '/lua/extras',
  name = 'transparency',
  event = 'VeryLazy',
  config = function()
    local groups = {
      'Normal',
      'NormalFloat',
      'FloatBorder',
      'Pmenu',
      'Terminal',
      'EndOfBuffer',
      'FoldColumn',
      'Folded',
      'SignColumn',
      'LineNr',
      'DiagnosticSignWarn',
      'DiagnosticSignError',
      'DiagnosticSignHint',
      'DiagnosticSignInfo',
      'IndentLineChar',
    }

    for _, group in ipairs(groups) do
      local hl = vim.api.nvim_get_hl(0, { name = group })
      hl.bg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end
  end,
}
