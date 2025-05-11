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
local grep_in = function()
  local node = api.tree.get_node_under_cursor()
  if not node then
    return
  end
  local path = node.absolute_path
  if node.type ~= "directory" and node.parent then
    path = node.parent.absolute_path
  end
  require("telescope.builtin").live_grep {
    search_dirs = { path },
    prompt_title = string.format("Grep in [%s]", vim.fs.basename(path)),
  }
end

return {
  lefty = lefty,
  righty = righty,
  grep_in = grep_in,
}
