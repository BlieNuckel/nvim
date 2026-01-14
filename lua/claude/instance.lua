local state = require "claude.state"

local M = {}

function M.get(id)
  return state.instances[id or state.active_id]
end

function M.get_active()
  return M.get(state.active_id)
end

function M.buf_is_valid(inst)
  return inst and inst.buf and vim.api.nvim_buf_is_valid(inst.buf)
end

function M.get_sorted_ids()
  local ids = {}
  for inst_id in pairs(state.instances) do
    table.insert(ids, inst_id)
  end
  table.sort(ids)
  return ids
end

function M.get_index(id)
  local ids = M.get_sorted_ids()
  for i, inst_id in ipairs(ids) do
    if inst_id == id then
      return i, #ids
    end
  end
  return 1, math.max(1, #ids)
end

function M.get_fallback_id(closed_id)
  local ids = M.get_sorted_ids()
  local fallback = nil
  for _, inst_id in ipairs(ids) do
    if inst_id < closed_id then
      fallback = inst_id
    end
  end
  if fallback then
    return fallback
  end
  for _, inst_id in ipairs(ids) do
    if inst_id ~= closed_id then
      return inst_id
    end
  end
  return nil
end

function M.create_buf(inst)
  if M.buf_is_valid(inst) then
    return inst.buf
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "hide"
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false

  inst.buf = buf
  return buf
end

return M
