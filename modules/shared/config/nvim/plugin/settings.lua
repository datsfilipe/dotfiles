vim.opt.guicursor = 'a:blinkon6'

vim.o.sw = 2
vim.o.ts = 2
vim.o.et = true
vim.o.wrap = false

vim.opt.list = true
vim.opt.listchars = { lead = '.', trail = '.', tab = '  -' }

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'

vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.wo.foldtext = ''

vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldclose = '<',
  foldopen = '>',
  foldsep = ' ',
  msgsep = '─',
}

vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.signcolumn = 'yes'

vim.opt.wildignore:append { '.DS_Store' }
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.pumheight = 15

vim.opt.diffopt:append 'vertical,context:99'

vim.opt.shortmess:append {
  w = true,
  s = true,
}

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.swapfile = false
vim.opt.isfname:append '@-@'
vim.o.backup = true
vim.o.backupdir = vim.fn.expand '~/.local/share/nvim/backup'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.o.undofile = true

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.netrw_banner = 0
