require "configs.autocmds.diagnostic"

local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("MyLspGlance", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local map = function(keybinding, cmd, desc)
      vim.keymap.set("n", keybinding, cmd, { buffer = bufnr, desc = desc })
    end
    local del = function(keybinding)
      pcall(vim.keymap.del, "n", keybinding, { buffer = bufnr })
    end
    vim.schedule(function()
      del "gd"
      del "gr"
      del "gy"
      del "gm"

      map("gd", "<CMD>Glance definitions<CR>", "Glance Definitions")
      map("gr", "<CMD>Glance references<CR>", "Glance References")
      map("gy", "<CMD>Glance type_definitions<CR>", "Glance Type Definitions")
      map("gm", "<CMD>Glance implementations<CR>", "Glance Implementations")
    end)
  end,
})

autocmd("CursorHold", {
  pattern = "*",
  command = "checktime",
})

autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

autocmd("BufWritePre", {
  callback = function()
    if vim.bo.ft == "typescript" then
      vim.lsp.buf.code_action {
        context = { diagnostics = vim.diagnostic.get(0), only = { "source.organizeImports" } },
        apply = true,
      }
    end
  end,
})
