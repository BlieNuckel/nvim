require "nvchad.options"

-- add yours here!

local o = vim.o
local g = vim.g

o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.scrolloff = 10
o.foldcolumn = "1"
o.autoread = true
o.updatetime = 2000
o.exrc = true
o.clipboard = "unnamedplus"
g.copilot_no_tab_map = true
vim.wo.wrap = false
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.filetype.add {
  extension = {
    ["http"] = "http",
  },
}
-- LSP Hover override to get borders
local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover {
    border = "rounded",
  }
end
