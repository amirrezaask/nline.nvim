local wrappers = {}

function wrappers.square_brackets(item)
  return function()
    local result = item
    if type(item) == 'function' then
      result = result()
    end
    if result == nil or result == '' then
      return ''
    end
    return '[ ' .. result .. ' ]'
  end
end

function wrappers.parens(item)
  return function()
    local result = item
    if type(item) == 'function' then
      result = result()
    end
    if result == nil or result == '' then
      return ''
    end
    return '( ' .. result .. ' )'
  end
end

function wrappers.curly_brackets(item)
  return function()
    local result = item
    if type(item) == 'function' then
      result = result()
    end
    if result == nil or result == '' then
      return ''
    end
    return '{ ' .. result .. ' }'
  end
end
-- TODO: wrapper for adding highlight to an item

return wrappers
