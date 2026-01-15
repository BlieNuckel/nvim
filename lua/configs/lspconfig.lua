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
  "elixir-ls",
}

for _, server in ipairs(servers) do
  local config_path = vim.fn.stdpath "config" .. "/lsp/" .. server .. ".lua"
  if vim.fn.filereadable(config_path) == 1 then
    vim.lsp.config(server, dofile(config_path))
  end
end

vim.lsp.enable(servers)

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
}
