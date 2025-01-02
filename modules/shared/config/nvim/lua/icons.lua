local M = {}

M.diagnostics = {
  ERROR = 'E',
  WARN = 'W',
  HINT = 'I',
  INFO = 'I',
}

M.symbol_kinds = {
  Array = '[array]',
  Class = '[class]',
  Color = '[color]',
  Constant = '[constant]',
  Constructor = '[constructor]',
  Enum = '[enum]',
  EnumMember = '[enumMember]',
  Event = '[event]',
  Field = '[field]',
  File = '[file]',
  Folder = '[folder]',
  Function = '[function]',
  Interface = '[interface]',
  Keyword = '[keyword]',
  Method = '[method]',
  Module = '[module]',
  Operator = '[operator]',
  Property = '[property]',
  Reference = '[reference]',
  Snippet = '[snippet]',
  Struct = '[struct]',
  Text = '[text]',
  TypeParameter = '[typeParameter]',
  Unit = '[unit]',
  Value = '[value]',
  Variable = '[variable]',
}

M.lazy_icons = {
  cmd = '[cmd]',
  config = '[conf]',
  event = '[evnt]',
  favorite = '[fav]',
  ft = '[ft]',
  init = '[init]',
  import = '[imp]',
  keys = '[key]',
  lazy = '[#]',
  loaded = '[x]',
  not_loaded = '[ ]',
  plugin = '[plug]',
  runtime = '[runtime]',
  require = '[req]',
  source = '[src]',
  start = '[start]',
  task = '[done]',
  list = {
    '*',
    '->',
    '+',
    '-',
  },
}

return M
