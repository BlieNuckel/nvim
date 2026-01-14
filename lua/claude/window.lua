local state = require "claude.state"
local instance = require "claude.instance"
local attention = require "claude.attention"

local M = {}

local function is_fixed_width_win(win)
  local win_buf = vim.api.nvim_win_get_buf(win)
  local ft = vim.bo[win_buf].filetype
  return ft == "NvimTree" or ft == "neo-tree" or ft == "nvim-tree"
end

local function capture_fixed_wins()
  local fixed_wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_fixed_width_win(win) then
      fixed_wins[win] = vim.api.nvim_win_get_width(win)
    end
  end
  return fixed_wins
end

local function restore_fixed_widths(fixed_wins)
  for win, w in pairs(fixed_wins) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_set_width(win, w)
    end
  end
end

local function get_term_width(inst)
  local fixed_width = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if is_fixed_width_win(win) then
      fixed_width = fixed_width + vim.api.nvim_win_get_width(win)
    end
  end

  local total = vim.o.columns
  local ratio = inst.expanded and state.WIDTH_EXPANDED or state.WIDTH_NORMAL
  return math.floor((total - fixed_width) * ratio)
end

function M.save_code_win()
  local current = vim.api.nvim_get_current_win()
  if state.sidebar_win and current == state.sidebar_win then
    return
  end
  state.last_code_win = current
end

function M.get_sidebar_win()
  if state.sidebar_win and vim.api.nvim_win_is_valid(state.sidebar_win) then
    return state.sidebar_win
  end
  state.sidebar_win = nil
  return nil
end

function M.update_winbar()
  local win = M.get_sidebar_win()
  if not win then
    return
  end

  local inst = instance.get_active()
  if not inst then
    vim.wo[win].winbar = ""
    return
  end

  local idx, total = instance.get_index(inst.id)
  vim.wo[win].winbar = string.format(" %s [%d/%d]", inst.name, idx, total)
end

function M.open_sidebar()
  local win = M.get_sidebar_win()
  if win then
    return win
  end

  local fixed_wins = capture_fixed_wins()
  vim.cmd "botright vsplit"
  state.sidebar_win = vim.api.nvim_get_current_win()

  vim.wo[state.sidebar_win].number = false
  vim.wo[state.sidebar_win].relativenumber = false
  vim.wo[state.sidebar_win].signcolumn = "no"
  vim.wo[state.sidebar_win].winfixwidth = true

  local inst = instance.get_active()
  vim.api.nvim_win_set_width(state.sidebar_win, get_term_width(inst or { expanded = false }))
  restore_fixed_widths(fixed_wins)

  return state.sidebar_win
end

function M.close_sidebar()
  local win = M.get_sidebar_win()
  if win then
    vim.api.nvim_win_close(win, true)
    state.sidebar_win = nil
  end
end

function M.show_instance(inst)
  local win = M.open_sidebar()
  local buf = instance.create_buf(inst)

  vim.api.nvim_win_set_buf(win, buf)

  if vim.bo[buf].buftype == "nofile" then
    local id = inst.id
    vim.api.nvim_win_call(win, function()
      vim.fn.termopen("claude", {
        cwd = inst.cwd,
        env = { CLAUDE_NVIM_ID = tostring(id) },
        on_exit = function()
          attention.clear(id)
          local i = state.instances[id]
          if i and instance.buf_is_valid(i) then
            vim.api.nvim_buf_delete(i.buf, { force = true })
          end
          if state.active_id == id then
            local fallback = instance.get_fallback_id(id)
            state.instances[id] = nil
            state.active_id = fallback
            if state.active_id and M.get_sidebar_win() then
              M.show_instance(state.instances[state.active_id])
            elseif not state.active_id then
              M.close_sidebar()
            end
          else
            state.instances[id] = nil
          end
          M.update_winbar()
        end,
      })
    end)
  end

  M.update_winbar()
end

function M.resize()
  local inst = instance.get_active()
  if not inst then
    return
  end

  local win = M.get_sidebar_win()
  if not win then
    return
  end

  local fixed_wins = capture_fixed_wins()
  vim.api.nvim_win_set_width(win, get_term_width(inst))
  restore_fixed_widths(fixed_wins)
end

return M
