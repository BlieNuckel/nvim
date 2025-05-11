local nav = require "plugins.nvimtree.nav"

local function on_attach(bufnr)
  local api = require "nvim-tree.api"
  local map = vim.keymap.set
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)
  map("n", "h", nav.lefty, opts "Lefty")
  map("n", "l", nav.righty, opts "Righty")
  map("n", "H", api.tree.collapse_all, opts "Collapse All")
  map("n", "<C-f>", nav.grep_in, opts "Grep in")
end

return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup {
      on_attach = on_attach,
      update_focused_file = {
        enable = true,
        ignore_list = {},
      },
      filters = {
        git_ignored = false,
        dotfiles = false,
      },
      view = {
        width = 25,
      },
    }
  end,
}
