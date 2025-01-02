local function toggle_qf()
  local win_id = vim.fn.getqflist({ winid = 0 }).winid
  if win_id ~= nil and win_id ~= 0 then
    vim.cmd 'ccl'
  else
    vim.cmd 'copen'
    vim.cmd 'wincmd p'
  end
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/extras',
  name = 'DATSquickfixlist',
  keys = {
    { ';e', toggle_qf, desc = 'quickfix list: toggle' },
    {
      '<C-p>',
      '<cmd>cprev<CR>zz<cmd>lua print("qflist: prev")<CR>',
      desc = 'quickfix list: prev',
    },
    {
      '<C-n>',
      '<cmd>cnext<CR>zz<cmd>lua print("qflist: next")<CR>',
      desc = 'quickfix list: next',
    },
    {
      ';E',
      '<cmd>call setqflist([], "r")<CR><cmd>ccl<CR><cmd>lua print("qflist: clear")<CR>',
      desc = 'quickfix list: clear',
    },
  },
  config = function()
    for i = 1, 9 do
      vim.keymap.set('n', '<C-e>' .. i, function()
        vim.cmd('cc ' .. i)
        print('qflist: selected ' .. i)
      end, { desc = 'quickfix list: select ' .. i })
    end
  end,
}
