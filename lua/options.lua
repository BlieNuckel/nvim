require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.scrolloff = 10
o.autoread = true
o.updatetime = 2000
o.clipboard = "unnamedplus"
o.winborder = "rounded"
vim.wo.wrap = false

vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  command = "checktime",
})
