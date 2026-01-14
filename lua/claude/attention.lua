local M = {}

local ATTENTION_DIR = "/tmp"

local function get_attention_path(id)
  return ATTENTION_DIR .. "/claude-nvim-attention-" .. id
end

function M.needs_attention(id)
  return vim.fn.filereadable(get_attention_path(id)) == 1
end

function M.clear(id)
  local path = get_attention_path(id)
  if vim.fn.filereadable(path) == 1 then
    vim.fn.delete(path)
  end
end

return M
