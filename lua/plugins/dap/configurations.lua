local dap = require "dap"

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    console = "integratedTerminal",
    env = {
      LISTINGS_QUEUE_FOR_DEV = "!SQS",
    },
  },
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch connectmeto",
    program = "${workspaceFolder}/server.js",
    cwd = "${workspaceFolder}",
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
