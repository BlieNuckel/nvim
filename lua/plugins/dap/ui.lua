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

-- Override K keymap during debug session
dap.listeners.after.event_initialized["override_K"] = function()
  vim.keymap.set({ "n", "v" }, "K", function()
    require("dap.ui.widgets").hover()
  end, { desc = "DAP Hover" })
end

local function restore_K()
  vim.keymap.del({ "n", "v" }, "K")
end

dap.listeners.before.event_terminated["restore_K"] = restore_K
dap.listeners.before.event_exited["restore_K"] = restore_K
