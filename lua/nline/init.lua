NLineStatusLineGenerator = nil

local function process(e)
  if type(e) == "function" then
    return process(e())
  elseif type(e) == "string" then
    return e
  elseif type(e) == "table" then
    return table.concat(e, "")
  end
end

local function make_statusline(elements, opts)
  opts = opts or {}
  NLineStatusLineGenerator = function()
    local _parts = {}
    for _, e in ipairs(elements) do
      local processed = process(e)
      if processed ~= "" then
        table.insert(_parts, processed)
      end
    end
    return table.concat(_parts, opts.delimiter or "")
  end
  vim.opt.statusline = "%!v:lua.NLineStatusLineGenerator()"
end

return {
  make = make_statusline,
}
