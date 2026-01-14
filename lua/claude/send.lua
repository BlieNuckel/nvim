local instance = require "claude.instance"

local M = {}

function M.to_instance(id, text)
  local inst = instance.get(id)
  if not instance.buf_is_valid(inst) then
    vim.notify("Claude terminal not open", vim.log.levels.WARN)
    return false
  end
  local chan = vim.b[inst.buf].terminal_job_id
  if not chan then
    vim.notify("Claude terminal channel not found", vim.log.levels.WARN)
    return false
  end
  vim.api.nvim_chan_send(chan, text)
  return true
end

function M.selection(target_id, callbacks)
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    vim.notify("No visual selection", vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  if start_line > end_line then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  elseif start_line == end_line and start_col > end_col then
    start_col, end_col = end_col, start_col
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if #lines == 0 then
    return
  end

  if mode == "v" then
    if #lines == 1 then
      lines[1] = lines[1]:sub(start_col, end_col)
    else
      lines[1] = lines[1]:sub(start_col)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
  end

  local text = table.concat(lines, "\n")
  local file = vim.fn.expand "%:."
  local formatted = string.format("From %s (lines %d-%d):\n```\n%s\n```", file, start_line, end_line, text)

  vim.cmd "normal! \27"

  local inst = instance.get(target_id)
  if not inst then
    callbacks.create_new()
    inst = instance.get_active()
  end

  local was_closed = not callbacks.is_open()
  callbacks.focus(inst.id)
  vim.cmd "startinsert"

  if was_closed then
    vim.defer_fn(function()
      M.to_instance(inst.id, formatted)
    end, 100)
  else
    M.to_instance(inst.id, formatted)
  end
end

function M.diagnostics(scope, target_id, callbacks)
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand "%:."
  local diags

  if scope == "line" then
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    diags = vim.diagnostic.get(bufnr, { lnum = line })
  else
    diags = vim.diagnostic.get(bufnr)
  end

  if #diags == 0 then
    local msg = scope == "line" and "No diagnostics on current line" or "No diagnostics in current file"
    vim.notify(msg, vim.log.levels.INFO)
    return
  end

  local severity_names = { "ERROR", "WARN", "INFO", "HINT" }
  local lines = { string.format("Diagnostics from %s:", file) }

  for _, d in ipairs(diags) do
    local sev = severity_names[d.severity] or "UNKNOWN"
    table.insert(lines, string.format("  Line %d: [%s] %s", d.lnum + 1, sev, d.message))
  end

  local text = table.concat(lines, "\n") .. "\n"

  local inst = instance.get(target_id)
  if not inst then
    callbacks.create_new()
    inst = instance.get_active()
  end

  local was_closed = not callbacks.is_open()
  callbacks.focus(inst.id)
  vim.cmd "startinsert"

  if was_closed then
    vim.defer_fn(function()
      M.to_instance(inst.id, text)
    end, 100)
  else
    M.to_instance(inst.id, text)
  end
end

return M
