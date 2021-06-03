local git = {}

local has_plenary, Job = pcall(require,'plenary.job')

if not has_plenary then
  vim.api.nvim_err_writeln('You need plenary to use git parts')
  return
end

local default_icons = {
  git_insertions = '+',
  git_changed = '~',
  git_deletions = '-'
}

function git.changes(icons)
  icons = icons or {}
  return function()
    if vim.api.nvim_buf_get_option(0, 'bufhidden') ~= ""
        or vim.api.nvim_buf_get_option(0, 'buftype') == 'nofile' then
      return ''
    end

    if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) ~= 1 then
      return ''
    end
    local parse_shortstat_output = function(s)
      local result = {}

      local git_changed = vim.regex([[\(\d\+\)\( file changed\)\@=]])
      local git_insertions = vim.regex([[\(\d\+\)\( insertions\)\@=]])
      local git_deletions = vim.regex([[\(\d\+\)\( deletions\)\@=]])

      local changed = {git_changed:match_str(s)}
      if not vim.tbl_isempty(changed) then
        result['changed'] = string.sub(s, changed[1] + 1, changed[2])
      end

      local insert = {git_insertions:match_str(s)}
      if not vim.tbl_isempty(insert) then
        result['insertions'] = string.sub(s, insert[1] + 1, insert[2])
      end

      local delete = {git_deletions:match_str(s)}
      if not vim.tbl_isempty(delete) then
        result['deletions'] = string.sub(s, delete[1] + 1, delete[2])
      end
      return result
    end

    local j = Job:new({
      command = "git",
      args = {"diff", "--shortstat", vim.api.nvim_buf_get_name(0)},
      cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
    }):sync()
    local ok, result = pcall(function()
      return parse_shortstat_output(vim.trim(j[1]))
    end)
    if not ok then return '' end
    if not result then return '' end
    local output = {}
    if result.changed then table.insert(output, string.format('%s%s', default_icons.git_changed, result.changed)) end
    if result.deletions then table.insert(output, string.format('%s%s', default_icons.git_deletions, result.deletions)) end
    if result.insertions then table.insert(output, string.format('%s%s',default_icons.git_insertions, result.insertions)) end
    if vim.tbl_isempty(output) then return '' end
    return table.concat(output, ', ')
  end
end

function git.branch()
  return function()
    local branch
    local success
    success, branch = pcall(vim.fn['fugitive#head'])
    if success and branch ~= '' then
      return branch
    else
      local j = Job:new({
        command = "git",
        args = {"branch", "--show-current"},
        cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h"),
      })

      local ok, result = pcall(function()
        return vim.trim(j:sync()[1])
      end)
      if ok then return result end
    end
  end
end

return git
