return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    require "plugins.dap.adapters"
    require "plugins.dap.configurations"
    require "plugins.dap.ui"
    require "plugins.dap.copy"
  end,
}
