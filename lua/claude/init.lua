local M = {}

local state = {
  buf = nil,
  last_code_win = nil,
  was_insert_mode = false,
}

local function get_win_for_buf(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

function M.is_open()
  return get_win_for_buf(state.buf) ~= nil
end

function M.is_focused()
  local win = get_win_for_buf(state.buf)
  return win and vim.api.nvim_get_current_win() == win
end

local function save_code_win()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  if current_buf ~= state.buf then
    state.last_code_win = current_win
  end
end

local function open_terminal()
  local term = require "nvchad.term"
  local win_ratios = {}
  local total = vim.o.columns

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    win_ratios[win] = vim.api.nvim_win_get_width(win) / total
  end

  term.toggle {
    pos = "vsp",
    id = "claudeTerm",
    cmd = "claude",
    size = 0.25,
    winopts = { winfixwidth = true },
  }

  vim.cmd "wincmd L"
  local term_win = vim.api.nvim_get_current_win()
  local term_width = math.floor(total * 0.25)
  local remaining = total - term_width

  vim.api.nvim_win_set_width(term_win, term_width)
  for win, ratio in pairs(win_ratios) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_width(win, math.floor(remaining * ratio))
    end
  end

  state.buf = vim.api.nvim_win_get_buf(term_win)
end

local function close_terminal()
  local term = require "nvchad.term"
  term.toggle {
    pos = "vsp",
    id = "claudeTerm",
    cmd = "claude",
    size = 0.25,
  }
end

function M.toggle()
  local was_open = M.is_open()
  if was_open then
    save_code_win()
    close_terminal()
  else
    save_code_win()
    open_terminal()
  end
end

function M.focus()
  save_code_win()
  if not M.is_open() then
    open_terminal()
    return
  end
  local win = get_win_for_buf(state.buf)
  if win then
    vim.api.nvim_set_current_win(win)
  end
end

function M.return_to_code()
  if state.last_code_win and vim.api.nvim_win_is_valid(state.last_code_win) then
    vim.api.nvim_set_current_win(state.last_code_win)
  end
end

function M.toggle_focus()
  if M.is_focused() then
    state.was_insert_mode = vim.fn.mode() == "t"
    vim.cmd "stopinsert"
    M.return_to_code()
  else
    M.focus()
    if state.was_insert_mode then
      vim.cmd "startinsert"
    end
  end
end

local function send_to_claude(text)
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    vim.notify("Claude terminal not open", vim.log.levels.WARN)
    return false
  end
  local chan = vim.b[state.buf].terminal_job_id
  if not chan then
    vim.notify("Claude terminal channel not found", vim.log.levels.WARN)
    return false
  end
  vim.api.nvim_chan_send(chan, text)
  return true
end

function M.send_selection()
  local mode = vim.fn.mode()
  if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
    vim.notify("No visual selection", vim.log.levels.WARN)
    return
  end

  local start_pos = vim.fn.getpos "v"
  local end_pos = vim.fn.getpos "."
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]

  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
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
  if not M.is_open() then
    open_terminal()
  end
  M.focus()
  vim.cmd "startinsert"
  send_to_claude(formatted)
end

function M.cleanup()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end
  state.buf = nil
end

function M.send_diagnostics(scope)
  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand "%:."
  local diagnostics

  if scope == "line" then
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
  else
    diagnostics = vim.diagnostic.get(bufnr)
  end

  if #diagnostics == 0 then
    local msg = scope == "line" and "No diagnostics on current line" or "No diagnostics in current file"
    vim.notify(msg, vim.log.levels.INFO)
    return
  end

  local severity_names = { "ERROR", "WARN", "INFO", "HINT" }
  local lines = { string.format("Diagnostics from %s:", file) }

  for _, d in ipairs(diagnostics) do
    local sev = severity_names[d.severity] or "UNKNOWN"
    table.insert(lines, string.format("  Line %d: [%s] %s", d.lnum + 1, sev, d.message))
  end

  local text = table.concat(lines, "\n") .. "\n"

  if not M.is_open() then
    open_terminal()
  end
  M.focus()
  vim.cmd "startinsert"
  send_to_claude(text)
end

return M
