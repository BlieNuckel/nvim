-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "nano-light",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = { load_on_startup = true }
M.term = {
  float = {
    border = "rounded",
  },
}
M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    order = { "mode", "f", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "lineInfo" },
    modules = {
      lineInfo = function()
        return "%#st_pos_icon#  %#st_pos_text# %l/%L (:%v) "
      end,
      f = "%f",
    },
  },
}

return M
