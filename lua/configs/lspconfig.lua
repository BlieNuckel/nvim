local servers = {
  "csharp_ls",
  "ts_ls",
  "gopls",
  "html",
  "cssls",
  "elmls",
  "eslint",
  "kulala_ls",
  "pyright",
}
vim.lsp.enable(servers)

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
}
