return {
  "dlyongemallo/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>vd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
  },
  dependencies = {
    "rickhowe/diffchar.vim",
  },
}
