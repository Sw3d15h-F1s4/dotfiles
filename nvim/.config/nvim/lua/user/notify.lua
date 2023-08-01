local M = {
  "rcarriga/nvim-notify",
  event = "VimEnter"
}

M.opts = {
  timeout = 3000,
  max_height = function()
    return math.floor(vim.o.lines * 0.75)
  end,
  max_width = function()
    return math.floor(vim.o.columns * 0.75)
  end,
}

function M.config()
  require("notify").setup({
    background_colour = "#000000",
  })
end

M.init = function()
  vim.notify = require("notify")
end

return M
