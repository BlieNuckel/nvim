local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
    end

    map("gd", "<CMD>Glance definitions<CR>", "Glance Definition")
    map("gr", "<CMD>Glance references<CR>", "Glance References")
    map("gy", "<CMD>Glance type_definitions<CR>", "Glance Type Definition")
    map("gm", "<CMD>Glance implementations<CR>", "Glance implementations")
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
