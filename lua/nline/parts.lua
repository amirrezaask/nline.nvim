local parts = {}

function parts.mode(opts)
  local default_opts = {
    normal = 'NormalMode',
    visual = 'VisualMode',
    visual_block = 'VisualBlockMode',
    insert = 'InsertMode',
    command = 'CommandMode',
    terminal = 'TerminalMode'
  }
  opts = opts or {}
  return function()
    local m = vim.api.nvim_get_mode().mode
    if m == 'n' then
      return string.format('%%#%s# Normal %%*', opts.normal or default_opts.normal)
    elseif m == 'v' or m == 'V' then
      return string.format('%%#%s# Visual %%*', opts.visual or default_opts.visual)
    elseif m == '' then
      return string.format('%%#%s# VisualBlock %%*', opts.visual_block or default_opts.visual_block)
    elseif m == 'i' then
      return string.format('%%#%s# Insert %%*', opts.insert or default_opts.insert)
    elseif m == 'ic' or m == 'ix' then
      return string.format('%%#%s# IComplete %%*', opts.insert or default_opts.insert)
    elseif m == 'c' then
      return string.format('%%#%s# Command %%*', opts.command or default_opts.command)
    elseif m == 't' then
      return string.format('%%#%s# Terminal %%*', opts.terminal or default_opts.terminal)
    else
      return m
    end
  end
end

parts.modified = '%m'
parts.readonly = '%r'
parts.space = ' '
parts.filename = '%f'
parts.filename_shorten = "%{pathshorten(expand('%:f'))}"
parts.pipe = '|'
parts.line = '%l'
parts.col = '%c'
parts.percentage_of_file = '%%%p'
parts.filetype = '%y'
parts.seperator = '%='
parts.colon = ':'

parts.icons = {
  file = function()
    local file = vim.api.nvim_buf_get_name(0)
    local has_icons, _ = pcall(require, 'nvim-web-devicons')
    if not has_icons then
      print('for having icon in drawer install `nvim-web-devicons`')
      return false
    end
    local icon, _ = require('nvim-web-devicons').get_icon(file, string.match(file, '%a+$'), { default = true })
    if icon ~= '' then
      return icon
    end
    return '' 
  end,
  git = function()
    local has_icons, _ = pcall(require, 'nvim-web-devicons')
    if not has_icons then
      print('for having icon in drawer install `nvim-web-devicons`')
      return false
    end
    local icon, _ = require('nvim-web-devicons').get_icon('git', 'git', { default = true })
    if icon ~= '' then
      return icon
    end
    return ''
  end
}

function parts.git_branch()
  -- TODO: make this use plenary
  local __BRANCH
  local success
  success, __BRANCH = pcall(vim.fn['fugitive#head'])
  if success and __BRANCH ~= '' then
    return __BRANCH
  end
  return __BRANCH
end

local has_lspstatus, lspstatus = pcall(require, 'lsp-status')
local default_icons = {
    error = '😡',
    warning = '😳',
    info = '🛈',
    hint = '😅',
    ok = '',
    ['function'] = '',
    git_insertions = '+',
    git_changed = '~',
    git_deletions = '-'
}

function parts.lsp_progress()
  if not has_lspstatus then return '' end
  return lspstatus.status_progress()
end

function parts.lsp_current_function(symbol)
  symbol = symbol or default_icons['function']
  return function()
    local ok, current_function = pcall(vim.api.nvim_buf_get_var,0, 'lsp_current_function')
    if ok and current_function ~= '' then
      if symbol == '' then
        return current_function
      else
        return symbol .. ' ' .. current_function
      end
    else
      return ''
    end
  end
end

function parts.lsp_diagnostics(icons)
  icons = icons or {}
  return function()
    local diag = lspstatus.diagnostics()
    local output = {}
    if diag.errors ~= 0 then
      table.insert(output, string.format("%s %s", icons.error or default_icons.error, diag.errors))
    end
    if diag.warnings ~= 0 then
      table.insert(output, string.format("%s %s", icons.warning or default_icons.warning, diag.warnings))
    end
    if diag.hints ~= 0 then
      table.insert(output, string.format("%s %s", icons.hint or default_icons.hint, diag.hints))
    end
    if diag.info ~= 0 then
      table.insert(output, string.format("%s %s", icons.info or default_icons.info, diag.info))
    end
    if #output < 1 then return icons.ok or default_icons.ok end
    return table.concat(output, ' ')
  end
end

function parts.git_changes(icons)
  icons = icons or {}
  return function()
    if vim.api.nvim_buf_get_option(0, 'bufhidden') ~= ""
        or vim.api.nvim_buf_get_option(0, 'buftype') == 'nofile' then
      return ''
    end

    if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) ~= 1 then
      return ''
    end
    local has_spawn, spawn = pcall(require, 'spawn')
    if not has_spawn then return '' end
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
        result['deletions'] = string.sub(s, insert[1] + 1, insert[2])
      end

      local delete = {git_deletions:match_str(s)}
      if not vim.tbl_isempty(delete) then
        result['insertions'] = string.sub(s, delete[1] + 1, delete[2])
      end
      return result
    end

    local j = require('plenary.job'):new({
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


return parts
