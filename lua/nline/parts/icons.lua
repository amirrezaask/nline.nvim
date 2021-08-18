local icons = {
  file = function()
    local file = vim.api.nvim_buf_get_name(0)
    local has_icons, _ = pcall(require, "nvim-web-devicons")
    if not has_icons then
      print "for having icon in drawer install `nvim-web-devicons`"
      return false
    end
    local icon, _ = require("nvim-web-devicons").get_icon(file, string.match(file, "%a+$"), { default = true })
    if icon ~= "" then
      return icon
    end
    return ""
  end,
  git_branch = function()
    local has_icons, _ = pcall(require, "nvim-web-devicons")
    if not has_icons then
      print "for having icon in drawer install `nvim-web-devicons`"
      return false
    end
    local icon, _ = require("nvim-web-devicons").get_icon("git", "git", { default = true })
    if icon ~= "" then
      return icon
    end
    return ""
  end,
}

return icons
