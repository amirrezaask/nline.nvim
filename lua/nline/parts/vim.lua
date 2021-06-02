local makers = require('nline.parts.util')
local static = makers.make_static
local with_hl = makers.with_hl

local parts = {}
parts.modified = static(function() return '%m' end)
parts.readonly = static('%r')
parts.space = static(' ')
parts.filename = static('%f')
parts.filename_shorten = static("%{pathshorten(expand('%:f'))}")
parts.pipe = static('|')
parts.line = static('%l')
parts.col = static('%c')
parts.percentage_of_file = static('%%%p')
parts.filetype = static('%y')
parts.seperator = static('%=')
parts.colon = static(':')

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
      return with_hl(opts.texts.normal or default_opts.texts.normal, opts.hls.normal or default_opts.hls.normal)
    elseif m == 'v' or m == 'V' then
      return with_hl(opts.texts.visual or default_opts.texts.visual, opts.hls.visual or default_opts.hls.visual)
    elseif m == '' then
      return with_hl(opts.texts.visual_block or default_opts.texts.visual_block, opts.hls.visual_block or default_opts.hls.visual_block)
    elseif m == 'i' then
      return with_hl(opts.texts.insert or default_opts.texts.insert, opts.hls.insert or default_opts.hls.insert)
    elseif m == 'ic' or m == 'ix' then
      return with_hl(opts.texts.insert_complete or default_opts.texts.insert_complete, opts.hls.insert_complete or default_opts.hls.insert_complete)
    elseif m == 'c' then
      return with_hl(opts.texts.command or default_opts.texts.command, opts.hls.command or default_opts.hls.command)
    elseif m == 't' then
      return with_hl(opts.texts.terminal or default_opts.texts.terminal, opts.hls.terminal or default_opts.hls.terminal)
    else
      return m
    end
  end
end

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
