require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local ufo = require "ufo"
local dap = require "dap"
local dapui = require "dapui"

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "zR", ufo.openAllFolds)
map("n", "zM", ufo.closeAllFolds)
map("n", "<leader>fW", require("telescope.builtin").grep_string, { desc = "Find word under cursor" })

-- Debugger keybindings
map("n", "<leader>dc", dap.continue, { desc = "Debugger Start/Continue" })
map("n", "<leader>dd", dap.disconnect, { desc = "Debugger Stop" })
map("n", "<leader>do", dap.step_over, { desc = "Debugger Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Debugger Step Into" })
map("n", "<leader>du", dap.step_out, { desc = "Debugger Step Out" })
map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>B", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Toggle Cond Breakpoint" })
map("n", "<leader>ui", dapui.toggle, { desc = "Debugger Toggle UI" })
map("n", "<Leader>dr", function()
  dap.repl.open()
end, { desc = "Debugger REPL" })
map({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "Debugger Hover" })

-- Copilot keybindings
map("i", "<C-c>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
