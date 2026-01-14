---@class ClaudeInstance
---@field id number
---@field buf number|nil
---@field name string|nil
---@field expanded boolean
---@field cwd string|nil

local M = {}

---@type table<number, ClaudeInstance>
M.instances = {}
M.next_id = 1
M.active_id = nil
M.last_code_win = nil
M.was_insert_mode = true
M.sidebar_win = nil

M.WIDTH_NORMAL = 0.25
M.WIDTH_EXPANDED = 0.40

return M
