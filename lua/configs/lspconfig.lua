local servers = { "csharp_ls", "ts_ls", "gopls", "html", "cssls", "elmls", "eslint", "kulala_ls" }
vim.lsp.enable(servers)

vim.diagnostic.config {
  virtual_lines = true,
}
-- read :h vim.lsp.config for changing options of lsp servers
