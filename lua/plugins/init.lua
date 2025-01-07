return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua", -- LSP and formatter for Lua
        "prettier", -- LSP and formatter for html,css
        "clangd", -- a powerful LSP for C++
        "clang-format",
        "typescript-language-server",
        "css-lsp",
        "html-lsp",
        "eslint",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "windwp/nvim-ts-autotag",
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      local api = require "nvim-tree.api"
      require("nvim-tree").setup {
        on_attach = function(bufnr)
          local function opts(desc)
            return { desc = "nvim-tree:" .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          api.config.mappings.default_on_attach(bufnr)
          local lefty = function()
            local node_at_cursor = api.tree.get_node_under_cursor()
            if node_at_cursor.nodes and node_at_cursor.open then
              api.node.open.edit()
            else
              api.node.navigate.parent()
            end
          end
          local righty = function()
            local node_at_cursor = api.tree.get_node_under_cursor()
            if node_at_cursor.nodes and not node_at_cursor.open then
              api.node.open.edit()
            else
              api.node.open.edit()
            end
          end
          vim.keymap.set("n", "h", lefty, opts "Lefty")
          vim.keymap.set("n", "<Left>", lefty, opts "Lefty")
          vim.keymap.set("n", "l", righty, opts "Righty")
          vim.keymap.set("n", "<Right>", lefty, opts "Righty")
          vim.keymap.set("n", "H", api.tree.collapse_all, opts "Collapse All")
        end,
        update_focused_file = {
          enable = true,
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cpp",
        "typescript",
        "javascript",
      },
    },
  },
}
