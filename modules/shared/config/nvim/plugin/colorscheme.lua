local nix = require 'nix'
local colorscheme = nix.colorscheme or 'vesper'

vim.cmd('colorscheme ' .. colorscheme)
