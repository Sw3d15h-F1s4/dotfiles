local M = {
  "rose-pine/neovim",
  lazy = false,    -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

M.name = "rose-pine"
function M.config()
  require("rose-pine").setup({
    variant = 'main',
    dim_nc_background = false,
    disable_italics = true,
    disable_background = true
  })


  local status_ok, _ = pcall(vim.cmd.colorscheme, M.name)
  if not status_ok then
    return
  end
end

return M
