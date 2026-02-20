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
    elixir = { "mix" },
    elm = { "elm_format" },
  },
  linters_by_ft = {
    javascript = { "eslint" },
    typescript = { "eslint" },
  },

  format_on_save = {
    timeout_ms = 10000,
    lsp_fallback = true,
  },
}

return options
