return {
  {
    'echasnovski/mini-git',
    main = 'mini.git',
    cmd = 'Git',
    opts = {},
    keys = {
      {
        ';gs',
        function()
          local status_output = vim.fn.system 'git status --porcelain'
          local qf_list = {}
          for file in status_output:gmatch '[^\r\n]+' do
            local status = file:sub(1, 2)
            local filename = file:sub(4)
            table.insert(qf_list, { filename = filename, text = status })
          end
          vim.fn.setqflist(qf_list)
          vim.cmd 'copen'
        end,
        desc = 'status',
      },
      { ';gA', '<cmd>Git add %<cr>', desc = 'add file' },
      { ';gU', '<cmd>Git reset HEAD --<cr>', desc = 'unstage changes' },
      { ';gc', '<cmd>Git commit<cr>', desc = 'commit' },
      { ';gd', '<cmd>vert Git diff %<cr>', desc = 'diff file' },
      { ';gD', '<cmd>vert Git diff<cr>', desc = 'diff' },
      { ';gl', '<cmd>vert Git log<cr>', desc = 'log' },
      {
        ';gi',
        function()
          require('mini.git').show_at_cursor { split = 'vertical' }
        end,
        desc = 'show info at cursor',
        mode = { 'n', 'x' },
      },
    },
  },
}
