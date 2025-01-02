return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'williamboman/mason.nvim',
    -- 'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'j-hui/fidget.nvim',
      event = { 'LspAttach' },
      opts = {
        progress = { display = { done_icon = 'OK' } },
      },
    },
  },
  config = function()
    require('lspconfig.ui.windows').default_options.border = 'none'

    local configure_server =
      require('plugins.nvim_lspconfig.server_config').configure_server
    local utils = require 'utils'
    local servers_to_install = {}

    if utils.is_bin_available 'node' or utils.is_bin_available 'rustc' then
      configure_server('rust_analyzer', {
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              enable = false,
            },
          },
        },
      })

      table.insert(servers_to_install, 'rust_analyzer')
    end

    if utils.is_bin_available 'go' then
      configure_server 'gopls'

      table.insert(servers_to_install, 'gopls')
    end

    if utils.is_bin_available 'node' then
      configure_server 'biome'
      configure_server 'bashls'

      configure_server('eslint', {
        filetypes = {
          'graphql',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        settings = { format = true },
      })

      configure_server('jsonls', {
        settings = {
          json = {
            validate = { enable = true },
          },
        },
      })

      configure_server('ts_ls', {
        server_capabilities = {
          documentFormattingProvider = false,
        },
        filetypes = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
      })

      for _, server in ipairs {
        'biome',
        'eslint-lsp',
        'json-lsp',
        'typescript-language-server',
        'bash-language-server',
      } do
        table.insert(servers_to_install, server)
      end
    end

    configure_server('lua_ls', {
      ---@param client vim.lsp.Client
      on_init = function(client)
        local path = client.workspace_folders
          and client.workspace_folders[1]
          and client.workspace_folders[1].name
        if not path then
          client.config.settings =
            vim.tbl_deep_extend('force', client.config.settings, {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                },
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                  },
                },
              },
            })
          client.notify(
            vim.lsp.protocol.Methods.workspace_didChangeConfiguration,
            { settings = client.config.settings }
          )
        end

        return true
      end,
      settings = {
        Lua = {
          format = { enable = false },
          hint = {
            enable = true,
            arrayIndex = 'Disable',
          },
          completion = { callSnippet = 'Replace' },
        },
      },
    })

    configure_server('cssls', {
      init_options = {
        provideFormatter = false,
      },
    })

    for _, server in ipairs { 'css-lsp', 'lua-language-server' } do
      table.insert(servers_to_install, server)
    end

    local extra = { 'stylua' }
    if utils.is_bin_available 'python3' then
      table.insert(extra, 'codespell')
    end

    require('mason').setup()
    require('mason-tool-installer').setup {
      ensure_installed = vim.list_extend(servers_to_install, extra),
    }
  end,
}
