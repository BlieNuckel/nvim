local state = require "claude.state"
local attention = require "claude.attention"
local instance = require "claude.instance"
local window = require "claude.window"
local send = require "claude.send"
local worktree = require "claude.worktree"

local M = {}

function M.new(opts)
  opts = type(opts) == "string" and { name = opts } or opts or {}
  local inst = {
    id = state.next_id,
    buf = nil,
    name = opts.name or ("claude-" .. state.next_id),
    expanded = false,
    cwd = opts.cwd,
  }
  state.instances[state.next_id] = inst
  state.next_id = state.next_id + 1

  window.save_code_win()
  state.active_id = inst.id
  window.show_instance(inst)

  if state.was_insert_mode then
    vim.cmd "startinsert"
  end

  return inst.id
end

function M.close(id)
  local inst = instance.get(id)
  if not inst then
    return
  end

  local was_active = state.active_id == inst.id
  attention.clear(inst.id)

  if was_active then
    local fallback = instance.get_fallback_id(inst.id)
    state.instances[inst.id] = nil
    state.active_id = fallback
    if state.active_id and window.get_sidebar_win() then
      window.show_instance(state.instances[state.active_id])
    elseif not state.active_id then
      window.close_sidebar()
    end
  else
    state.instances[inst.id] = nil
  end

  if instance.buf_is_valid(inst) then
    vim.api.nvim_buf_delete(inst.buf, { force = true })
  end
  window.update_winbar()
end

function M.get_count()
  local count = 0
  for _ in pairs(state.instances) do
    count = count + 1
  end
  return count
end

function M.list()
  local result = {}
  for id, inst in pairs(state.instances) do
    table.insert(result, {
      id = id,
      name = inst.name,
      is_active = id == state.active_id,
      needs_attention = attention.needs_attention(id),
    })
  end
  table.sort(result, function(a, b)
    return a.id < b.id
  end)
  return result
end

function M.select(id)
  if not state.instances[id] then
    return false
  end
  state.active_id = id
  if window.get_sidebar_win() then
    window.show_instance(state.instances[id])
  end
  return true
end

function M.cycle(direction)
  local ids = instance.get_sorted_ids()

  if #ids == 0 then
    return
  end
  if #ids == 1 then
    state.active_id = ids[1]
    window.update_winbar()
    return
  end

  local current_idx = 1
  for i, id in ipairs(ids) do
    if id == state.active_id then
      current_idx = i
      break
    end
  end

  if direction > 0 then
    state.active_id = ids[current_idx % #ids + 1]
  else
    state.active_id = ids[(current_idx - 2) % #ids + 1]
  end

  if window.get_sidebar_win() then
    window.show_instance(state.instances[state.active_id])
  end
end

function M.is_open()
  return window.get_sidebar_win() ~= nil
end

function M.is_focused()
  local win = window.get_sidebar_win()
  return win and vim.api.nvim_get_current_win() == win
end

function M.toggle()
  local inst = instance.get_active()

  if not inst then
    M.new()
    return
  end

  if window.get_sidebar_win() then
    state.was_insert_mode = M.is_focused() and vim.fn.mode() == "t"
    window.save_code_win()
    window.close_sidebar()
  else
    window.save_code_win()
    window.show_instance(inst)
    if state.was_insert_mode then
      vim.cmd "startinsert"
    end
  end
end

function M.toggle_all()
  M.toggle()
end

function M.focus(id)
  local inst = instance.get(id)
  if not inst then
    M.new()
    return
  end

  window.save_code_win()
  state.active_id = inst.id
  window.show_instance(inst)

  local win = window.get_sidebar_win()
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

function M.toggle_size()
  local inst = instance.get_active()
  if not inst then
    return
  end

  inst.expanded = not inst.expanded
  window.resize()
end

function M.send_selection(target_id)
  send.selection(target_id, {
    create_new = function()
      M.new()
    end,
    is_open = M.is_open,
    focus = M.focus,
  })
end

function M.send_diagnostics(scope, target_id)
  send.diagnostics(scope, target_id, {
    create_new = function()
      M.new()
    end,
    is_open = M.is_open,
    focus = M.focus,
  })
end

function M.send_alternate_path()
  send.alternate_path_inline()
end

function M.cleanup()
  window.close_sidebar()
  for id, inst in pairs(state.instances) do
    attention.clear(id)
    if instance.buf_is_valid(inst) then
      vim.api.nvim_buf_delete(inst.buf, { force = true })
    end
    state.instances[id] = nil
  end
  state.active_id = nil
end

function M.get_active_id()
  return state.active_id
end

function M.get_active_name()
  local inst = instance.get_active()
  return inst and inst.name or nil
end

function M.worktree_picker()
  worktree.picker(M.new)
end

function M.create_worktree()
  worktree.create(M.new)
end

return M
