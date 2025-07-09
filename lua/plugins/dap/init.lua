return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "jay-babu/mason-nvim-dap.nvim",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    -- Require basic DAP configuration
    local dap = require "dap"
    local dapui = require "dapui"

    -- Setup DAP UI
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
  end,
}
