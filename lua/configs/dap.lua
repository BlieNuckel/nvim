local dap = require "dap"

-- Configure the Node.js Adapter
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = { os.getenv "HOME" .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

dap.adapters.tsx = {
  type = "executable",
  command = "tsx",
  args = { os.getenv "HOME" .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
}

-- Standalone JavaScript/TypeScript debugging
dap.configurations.javascript = {
  {
    type = "node2",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    console = "integratedTerminal",
    outputCapture = "std",
  },
  {
    type = "node2",
    request = "launch",
    name = "Launch connectmeto",
    runTimeArgs = { "--inspect" },
    program = "${workspaceFolder}/server.js",
    console = "integratedTerminal",
    outputCapture = "std",
  },
  {
    type = "node2",
    request = "launch",
    name = "AVA Test File",
    program = "${workspaceFolder}/node_modules/ava/entrypoints/cli.mjs",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    args = { "${file}", "--tap", "--serial" },
    runTimeArgs = { "--inspect" },
    console = "integratedTerminal",
  },
}

dap.configurations.typescript = {
  {
    type = "tsx",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    outFiles = { "${workspaceFolder}/.build/**/*.js" },
    console = "integratedTerminal",
    outputCapture = "std",
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
