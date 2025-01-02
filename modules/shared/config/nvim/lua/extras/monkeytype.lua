vim.g.monkeytype_enabled = false

local function init()
  if not vim.g.monkeytype_enabled then
    return
  end

  local function notify()
    local msg = 'training time!'
    vim.notify(msg, vim.log.levels.INFO, {
      icon = '🐒',
      title = 'monkeytype',
      timeout = 5000,
    })
  end

  local function open_monkeytype()
    notify()
    local url = 'https://monkeytype.com/'
    local cmd = string.format('silent !xdg-open %s', url)
    vim.cmd(cmd)
  end

  local run_period = 15 * 60 * 1000 -- 15 min
  local timer = vim.loop.new_timer()

  if timer then
    timer:start(run_period, run_period, vim.schedule_wrap(open_monkeytype))
  end
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/extras',
  name = 'monkeytype',
  keys = {
    {
      '<leader>mt',
      function()
        vim.g.monkeytype_enabled = not vim.g.monkeytype_enabled
        print(
          'monkeytype surprise test is now '
            .. (vim.g.monkeytype_enabled and 'enabled' or 'disabled')
        )
      end,
      { desc = 'monkeytype surprise test: toggle' },
    },
  },
  config = function()
    init()
  end,
}
