local function with_hl(elem, hl)
    return string.format('%%#%s# %s %%*', hl, elem)
  end
local function static(item)
  return function(config)
    config = config or {}
    if config.hl then
      return with_hl(item, config.hl)
    else
      return item
    end
  end
end


local parts = {}
parts.modified = static('%m')
parts.readonly = static('%r')
parts.space = static(' ')
parts.pipe = static('|')
parts.line = static('%l')
parts.col = static('%c')
parts.percentage_of_file = static('%%%p')
parts.filetype = static('%y')
parts.seperator = static('%=')
parts.colon = static(':')

function parts.filename(opts)
  if opts.shorten then
    return static("%{pathshorten(expand('%:f'))}")
  else
    return static('%f')
  end
end

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


return parts
