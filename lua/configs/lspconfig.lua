require("nvchad.configs.lspconfig").defaults()

local servers = { "csharp-language-server" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
