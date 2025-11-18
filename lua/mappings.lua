require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local delmap = vim.keymap.del
local ufo = require "ufo"
local dap = require "dap"
local dapui = require "dapui"
local snacks = require "snacks"

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "zR", ufo.openAllFolds)
map("n", "zM", ufo.closeAllFolds)

-- Fzf lua keybindings
local pick = function(type)
  return function()
    snacks.picker.pick(type)
  end
end
map("n", "<leader><space>", pick "files", { desc = "Find Files" })
map("n", "<leader>fs", pick "smart", { desc = "Smart Find Files" })
map("n", "<leader>fw", pick "grep", { desc = "Live Grep" })
map("n", "<leader>fW", pick "grep_word", { desc = "Live Grep" })
map("n", "<leader>fb", pick "buffers", { desc = "Find Buffers" })
map("n", "<leader>fg", pick "git_status", { desc = "Find Git Changes" })
map("n", "<leader>fr", pick "recent", { desc = "Find Recent" })
map("n", "<leader>lg", snacks.lazygit.open, { desc = "Open Lazygit" })

-- Delete default telescope keybindings
delmap("n", "<leader>gt")

-- Blamer toggle
map("n", "<leader>bb", "<CMD>BlamerToggle<CR>", { desc = "Toggle Blamer" })

-- Leap keybindings
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
vim.keymap.set("n", "S", "<Plug>(leap-from-window)")

-- Debugger keybindings
map("n", "<leader>dc", dap.continue, { desc = "Debugger Start/Continue" })
map("n", "<leader>dd", dap.terminate, { desc = "Debugger Stop" })
map("n", "<leader>do", dap.step_over, { desc = "Debugger Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Debugger Step Into" })
map("n", "<leader>du", dap.step_out, { desc = "Debugger Step Out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Toggle Cond Breakpoint" })
map("n", "<leader>ui", dapui.toggle, { desc = "Debugger Toggle UI" })
map("n", "<Leader>dr", function()
  dap.repl.open()
end, { desc = "Debugger REPL" })
map({ "n", "v" }, "<Leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "Debugger Hover" })
