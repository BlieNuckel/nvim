local M = {}

local function is_term_open()
  local bufnr = vim.g.claudeTermBuf
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return true
    end
  end
  return false
end

function M.toggle()
  local term = require "nvchad.term"
  local was_open = is_term_open()

  local win_ratios = {}
  if not was_open then
    local total = vim.o.columns
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      win_ratios[win] = vim.api.nvim_win_get_width(win) / total
    end
  end

  term.toggle {
    pos = "vsp",
    id = "claudeTerm",
    cmd = "claude",
    size = 0.25,
    winopts = { winfixwidth = true },
  }

  if not was_open then
    vim.cmd "wincmd L"
    local term_win = vim.api.nvim_get_current_win()
    local total = vim.o.columns
    local term_width = math.floor(total * 0.25)
    local remaining = total - term_width

    vim.api.nvim_win_set_width(term_win, term_width)
    for win, ratio in pairs(win_ratios) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, math.floor(remaining * ratio))
      end
    end

    vim.g.claudeTermBuf = vim.api.nvim_win_get_buf(term_win)
  end
end

return M
