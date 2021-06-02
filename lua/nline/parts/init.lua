local parts = {}

-- @params opts: table
-- @params opts.hls table
-- @params opts.texts table
-- {
    -- hls = {
    --   normal = 'NormalMode',
    --   visual = 'VisualMode',
    --   visual_block = 'VisualBlockMode',
    --   insert = 'InsertMode',
    --   insert_complete = 'InsertMode',
    --   command = 'CommandMode',
    --   terminal = 'TerminalMode'
    -- },
    -- texts = {
    --   normal = 'Normal',
    --   visual = 'Visual',
    --   visual_block = 'VisualBlock',
    --   insert = 'Insert',
    --   insert_complete = 'IComplete',
    --   command = 'Command',
    --   terminal = 'Terminal'
    -- }
  -- }
function parts.mode(opts)
  local default_opts = {
    hls = {
      normal = 'NormalMode',
      visual = 'VisualMode',
      visual_block = 'VisualBlockMode',
      insert = 'InsertMode',
      insert_complete = 'InsertMode',
      command = 'CommandMode',
      terminal = 'TerminalMode'
    },
    texts = {
      normal = 'Normal',
      visual = 'Visual',
      visual_block = 'VisualBlock',
      insert = 'Insert',
      insert_complete = 'IComplete',
      command = 'Command',
      terminal = 'Terminal'
    }
  }
  opts = opts or {}
  opts.hls = opts.hls or {}
  opts.texts = opts.texts or {}
  return function()
    local m = vim.api.nvim_get_mode().mode
    if m == 'n' then
      return string.format('%%#%s# %s %%*', opts.hls.normal or default_opts.hls.normal, opts.texts.normal or default_opts.texts.normal)
    elseif m == 'v' or m == 'V' then
      return string.format('%%#%s# %s %%*', opts.hls.visual or default_opts.hls.visual, opts.texts.visual or default_opts.texts.visual)
    elseif m == '' then
      return string.format('%%#%s# %s %%*', opts.hls.visual_block or default_opts.hls.visual_block, opts.texts.visual_block or default_opts.texts.visual_block)
    elseif m == 'i' then
      return string.format('%%#%s# %s %%*', opts.hls.insert or default_opts.hls.insert, opts.texts.insert or default_opts.texts.insert)
    elseif m == 'ic' or m == 'ix' then
      return string.format('%%#%s# %s %%*', opts.hls.insert_complete or default_opts.hls.insert_complete, opts.texts.insert_complete or default_opts.texts.insert_complete)
    elseif m == 'c' then
      return string.format('%%#%s# %s %%*', opts.hls.command or default_opts.hls.command, opts.texts.command or default_opts.texts.command)
    elseif m == 't' then
      return string.format('%%#%s# %s %%*', opts.hls.terminal or default_opts.hls.terminal, opts.texts.terminal or default_opts.texts.terminal)
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

return parts
