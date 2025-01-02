return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  config = function()
    local function ts_formatters()
      local root_dir = vim.fn.getcwd()
      local prettier_config = vim.fn.findfile('.prettierrc', root_dir .. ';')
      if prettier_config ~= '' then
        return { 'prettier', 'prettierd' }
      end

      local biome_config = vim.fn.findfile('biome.json', root_dir .. ';')
      if biome_config ~= '' then
        return { 'biome' }
      end
    end

    require('conform').setup {
      formatters_by_ft = {
        lua = { 'stylua' },
        nix = { 'nixpkgs_fmt' },
        javascript = ts_formatters(),
        typescript = ts_formatters(),
        less = { 'prettier', 'prettierd' },
        css = { 'prettier', 'prettierd' },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    }
  end,
}
