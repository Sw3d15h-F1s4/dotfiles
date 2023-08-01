local M = {
  "stevearc/dressing.nvim",
  event = 'BufReadPre',
}

function M.config()
  require("dressing").setup {
    input = {
      enabled = true,
    },
    select = {
      enabled = true,
    },
  }
end

return M
