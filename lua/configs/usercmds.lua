local usercmd = vim.api.nvim_create_user_command

usercmd("BufCloseAll", function()
  vim.cmd "NvimTreeClose"
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype ~= "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.schedule(function()
    vim.wo.winfixwidth = false
  end)
end, {})

usercmd("BufCloseOthers", function()
  vim.cmd "NvimTreeClose"
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype ~= "terminal" then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
  vim.cmd "NvimTreeOpen"
end, {})

usercmd("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })

usercmd("ClaudeToggle", function()
  require("claude").toggle()
end, {})

usercmd("ClaudeFocus", function()
  require("claude").focus()
end, {})

usercmd("ClaudeReturn", function()
  require("claude").return_to_code()
end, {})

usercmd("ClaudeToggleFocus", function()
  require("claude").toggle_focus()
end, {})

usercmd("ClaudeSendSelection", function()
  require("claude").send_selection()
end, {})

usercmd("ClaudeSendDiagnostics", function(args)
  require("claude").send_diagnostics(args.args == "line" and "line" or "file")
end, { nargs = "?", complete = function()
  return { "file", "line" }
end })
