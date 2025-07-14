local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    less = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    http = { "kulala-fmt" },
    python = { "black" },
  },
  linters_by_ft = {
    javascript = { "eslint" },
    typescript = { "eslint" },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
