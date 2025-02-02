require "nvchad.options"

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!
o.relativenumber = true
o.scrolloff = 10
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.foldcolumn = "1"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.foldmethod = "manual"
o.wrap = false
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = false

if vim.fn.has "win32" == 1 then
  o.shell = "pwsh"
end
