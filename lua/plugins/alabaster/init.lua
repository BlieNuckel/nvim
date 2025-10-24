return {
  "p00f/alabaster.nvim",
  lazy = false, -- make sure we load this during startup
  priority = 1000, -- load before other plugins
  config = function()
    vim.cmd.colorscheme "alabaster"
  end,
}
