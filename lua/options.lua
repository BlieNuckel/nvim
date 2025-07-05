require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.scrolloff = 10
o.autoread = true
o.updatetime = 2000
o.clipboard = "unnamedplus"
vim.wo.wrap = false

-- LSP Hover override to get borders
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover {
    border = "rounded",
  }
end
