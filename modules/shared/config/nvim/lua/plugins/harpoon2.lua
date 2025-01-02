return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    {
      '<leader>h',
      function()
        local harpoon = require 'harpoon'
        harpoon.ui:toggle_quick_menu(harpoon:list(), { border = 'none' })
      end,
      desc = 'harpoon: toggle quick menu',
    },
    {
      ';h',
      function()
        local harpoon = require 'harpoon'
        harpoon:list():add()
        print 'harpoon: added'
      end,
      desc = 'harpoon: add',
    },
    {
      '<C-j>',
      function()
        local harpoon = require 'harpoon'
        harpoon:list():prev()
        print 'harpoon: prev'
      end,
      desc = 'harpoon: prev',
    },
    {
      '<C-k>',
      function()
        local harpoon = require 'harpoon'
        harpoon:list():next()
        print 'harpoon: next'
      end,
      desc = 'harpoon: next',
    },
  },
  config = function()
    local harpoon = require 'harpoon'

    for i = 1, 9 do
      vim.keymap.set('n', '<C-h>' .. i, function()
        harpoon:list():select(i)
        print('harpoon: selected ' .. i)
      end, { desc = 'harpoon: select ' .. i })
    end

    harpoon:extend {
      UI_CREATE = function(cx)
        vim.keymap.set('n', ';hv', function()
          harpoon.ui:select_menu_item { vsplit = true }
          print 'harpoon: v'
        end, { buffer = cx.bufnr, desc = 'harpoon: vsplit' })

        vim.keymap.set('n', ';hs', function()
          harpoon.ui:select_menu_item { split = true }
          print 'harpoon: h'
        end, { buffer = cx.bufnr, desc = 'harpoon: split' })
      end,
    }
  end,
}
