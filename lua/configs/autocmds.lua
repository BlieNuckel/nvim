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
    vim.schedule(function()
      -- Get only listed buffers (excludes hidden, unlisted buffers)
      local bufs = vim.tbl_filter(function(buf)
        return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
      end, vim.api.nvim_list_bufs())

      -- If only one buffer left and it's empty (no name and no content), show Nvdash
      if #bufs == 1 then
        local buf = bufs[1]
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        local is_empty = buf_name == "" and #buf_lines == 1 and buf_lines[1] == ""

        if is_empty then
          vim.cmd "Nvdash"
        end
      end
    end)
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
