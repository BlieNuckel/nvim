local dap = require "dap"
local dapui = require "dapui"

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

-- Highlight groups
vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#ffdef4" })

-- Signs
vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "blue", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "B", texthl = "blue", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "B", texthl = "orange", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "B", linehl = "DapStopped", numhl = "DapBreakpoint" })
vim.fn.sign_define("DapLogPoint", { text = "B", texthl = "yellow", linehl = "DapBreakpoint", numhl = "DapBreakpoint" })

