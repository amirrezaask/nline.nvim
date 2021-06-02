local util = {}

function util.with_hl(elem, hl)
  return string.format('%%#%s# %s %%*', hl, elem)
end

function util.make_static(item)
  return function(config)
    config = config or {}
    if config.hl then
      return util.with_hl(item, config.hl)
    else
      return item
    end
  end
end

return util
