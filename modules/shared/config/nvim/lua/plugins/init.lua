local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

local function get_plugin_specs()
  local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
  local plugins = {}

  for name, type in vim.fs.dir(plugins_dir) do
    if
      (type == 'file' or type == 'link')
      and name:match '%.lua$'
      and name ~= 'init.lua'
    then
      local module_name = 'plugins.' .. name:gsub('%.lua$', '')
      table.insert(plugins, { import = module_name })
    elseif type == 'directory' then
      local init_path = plugins_dir .. '/' .. name .. '/init.lua'
      if vim.loop.fs_stat(init_path) then
        local module_name = 'plugins.' .. name
        table.insert(plugins, { import = module_name .. '.init' })
      end
    end
  end

  local extras = {
    { import = 'extras' },
  }

  return { spec = vim.list_extend(plugins, extras) }
end

local plugins = get_plugin_specs()
local nix = require 'nix'
local colorscheme = nix.colorscheme or 'vesper'

require('lazy').setup {
  lockfile = nix.lockfile or vim.fn.stdpath 'config' .. '/lazy-lock.json',
  spec = plugins.spec,
  defaults = {
    lazy = true,
  },
  install = {
    colorscheme = { colorscheme },
    missing = false,
  },
  change_detection = { notify = false },
  rocks = {
    enabled = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'netrwPlugin',
        'netrw',
        'matchit',
        'matchparen',
        'vimball',
        'vimballPlugin',
        'rplugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    border = 'none',
    backdrop = 90,
    icons = require('icons').lazy_icons,
  },
}
