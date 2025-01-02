local function return_project_root()
  local path = vim.fn.expand '%:p:h'
  local git_path = vim.fn.finddir('.git', path .. ';')
  if git_path == '' then
    return nil
  else
    return vim.fn.fnamemodify(git_path, ':h')
  end
end

local function get_base_branch()
  local branch =
    vim.fn.system 'git symbolic-ref refs/remotes/origin/HEAD --short'
  return vim.fn.trim(branch)
end

local function get_current_branch()
  local branch = vim.fn.system 'git rev-parse --abbrev-ref HEAD'
  return vim.fn.trim(branch)
end

local function get_branch_info()
  local branch_info = vim.fn.systemlist('git status -b --porcelain')[1] or ''
  return branch_info:match '^## (.+)'
end

local function create_pr()
  local cli_installed = vim.fn.executable 'gh'
  if not cli_installed then
    vim.notify('gh cli not installed', vim.log.levels.WARN)
    return
  end

  local gh_auth_status = vim.fn.system 'gh auth status'
  if gh_auth_status ~= 'Logged in to github.com' then
    vim.notify('gh cli not authenticated', vim.log.levels.ERROR)
    return
  end

  local template_path = (
    return_project_root() .. '/.github/pull_request_template.md'
  ):match '^%a+://(.*)$'

  local base_branch = get_base_branch()
  local current_branch = get_current_branch()
  local branch_status = get_branch_info()

  if current_branch == base_branch:match '/(.+)' then
    vim.notify(
      'cannot create PR from the default branch: ' .. base_branch,
      vim.log.levels.WARN
    )
    return
  end

  local commits =
    vim.fn.systemlist('git log --oneline ' .. base_branch .. '..HEAD')

  if #commits == 0 then
    vim.notify(
      'no changes to be added to the pull request',
      vim.log.levels.WARN
    )
    return
  end

  local pr_message = ''
  if vim.fn.filereadable(template_path) == 1 then
    vim.cmd('tabe ' .. vim.fn.tempname())

    local template_lines = vim.fn.readfile(template_path)
    vim.fn.setline(1, template_lines)
    vim.cmd 'setlocal filetype=markdown'
  else
    vim.cmd('tabe ' .. vim.fn.tempname())

    pr_message = table.concat({
      '',
      '# Please enter the PR message for your changes. Lines starting',
      "# with '#' will be ignored, and an empty message aborts the PR.",
      '#',
      '# On branch ' .. branch_status .. '...' .. base_branch,
      '#',
      '# Changes to be included in this PR:',
    }, '\n')

    for _, commit in ipairs(commits) do
      pr_message = pr_message .. '\n#    ' .. commit
    end

    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(pr_message, '\n'))
    vim.bo[buf].filetype = 'gitcommit'
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = vim.api.nvim_get_current_buf(),
    callback = function()
      local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      local title, description = '', ''
      local is_description = false

      for _, line in ipairs(content) do
        if vim.fn.match(line, '^#') == -1 and line ~= '' then
          if not is_description then
            title = line
            is_description = true
          else
            description = description .. line .. '\n'
          end
        end
      end

      if title == '' then
        vim.notify(
          'invalid pull request message, please provide a title',
          vim.log.levels.ERROR
        )
        return
      end

      pr_message = string.format('%s\n\n%s', title, description)

      local command = string.format(
        'gh pr -a @me create --base %s --title "%s" --body "%s"',
        base_branch,
        title,
        pr_message
      )
      vim.fn.systemlist(command)

      if vim.v.shell_error == 0 then
        vim.notify('pull request created successfully', vim.log.levels.INFO)
      else
        vim.notify('failed to create pull request', vim.log.levels.ERROR)
      end
    end,
  })

  vim.notify(
    'edit the message and save the file to create a pull request',
    vim.log.levels.INFO
  )
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/extras',
  name = 'gh',
  keys = {
    { ';gP', create_pr, { desc = 'create pull request' } },
  },
}
