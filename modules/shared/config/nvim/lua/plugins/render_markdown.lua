return {
  'MeanderingProgrammer/render-markdown.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  ft = { 'markdown' },
  opts = {
    file_types = { 'markdown' },
    heading = {
      icons = { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
    },
    bullet = {
      icons = { '*', '-', '+', '-' },
    },
    checkbox = {
      unchecked = {
        icon = '[ ]',
      },
      checked = {
        icon = '[x]',
      },
    },
    callout = {
      note = { raw = '[!NOTE]', rendered = '- Note' },
      tip = { raw = '[!TIP]', rendered = '- Tip' },
      important = { raw = '[!IMPORTANT]', rendered = '- Important' },
      warning = { raw = '[!WARNING]', rendered = '- Warning' },
      caution = { raw = '[!CAUTION]', rendered = '- Caution' },
      abstract = { raw = '[!ABSTRACT]', rendered = '- Abstract' },
      todo = { raw = '[!TODO]', rendered = '- Todo' },
      success = { raw = '[!SUCCESS]', rendered = '- Success' },
      question = { raw = '[!QUESTION]', rendered = '- Question' },
      failure = { raw = '[!FAILURE]', rendered = '- Failure' },
      danger = { raw = '[!DANGER]', rendered = '- Danger' },
      bug = { raw = '[!BUG]', rendered = '- Bug' },
      example = { raw = '[!EXAMPLE]', rendered = '- Example' },
      quote = { raw = '[!QUOTE]', rendered = '- Quote' },
    },
    link = {
      image = '',
      email = '',
      hyperlink = '',
      custom = {
        web = { pattern = '^http[s]?://', icon = '' },
      },
    },
    sign = {
      enabled = false,
    },
  },
}
