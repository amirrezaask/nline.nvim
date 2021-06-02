local lsp = {}

local has_lspstatus, lspstatus = pcall(require, 'lsp-status')

if not has_lspstatus then
  vim.api.nvim_err_writeln('for lsp parts you need nvim-lua/lsp-status')
  return
end

local default_icons = {
    error = '😡',
    warning = '😳',
    info = '🛈',
    hint = '😅',
    ok = '',
    ['function'] = '',
}

function lsp.progress()
  if not has_lspstatus then return '' end
  return lspstatus.status_progress()
end

function lsp.current_function(symbol)
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

function lsp.diagnostics(config)
  config = config or {}
  config.icons = config.icons or {}
  local icons = config.icons
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

return lsp
