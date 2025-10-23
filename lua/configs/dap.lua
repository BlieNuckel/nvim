local dap = require "dap"

-- Configure js-debug-adapter
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug-adapter",
    args = { "${port}" },
  },
}

-- Standalone JavaScript/TypeScript debugging
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    console = "integratedTerminal",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch connectmeto",
    runtimeArgs = { "--inspect" },
    program = "${workspaceFolder}/server.js",
    console = "integratedTerminal",
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "AVA Test File",
    program = "${workspaceFolder}/node_modules/ava/entrypoints/cli.mjs",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    args = { "${file}", "--tap", "--serial" },
    runtimeArgs = { "--inspect" },
    console = "integratedTerminal",
  },
}

dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    console = "integratedTerminal",
    runtimeExecutable = "node",
    runtimeArgs = { "--import", "tsx", "${file}" },
  },
}

-- UI
vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, bg = "#ffdef4" })

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

