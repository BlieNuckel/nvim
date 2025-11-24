local lspconfig = require "lspconfig"

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

for _, server in ipairs(servers) do
  local config = {}

  local config_path = vim.fn.stdpath "config" .. "/lsp/" .. server .. ".lua"
  if vim.fn.filereadable(config_path) == 1 then
    config = dofile(config_path)
  end

  lspconfig[server].setup(config)
end

vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
}
