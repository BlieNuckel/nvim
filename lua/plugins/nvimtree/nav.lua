local api = require "nvim-tree.api"
local lefty = function()
  local node_at_cursor = api.tree.get_node_under_cursor()
  if node_at_cursor.nodes and node_at_cursor.open then
    api.node.open.edit()
  else
    api.node.navigate.parent()
  end
end
local righty = function()
  api.node.open.edit()
end

return {
  lefty = lefty,
  righty = righty,
}
