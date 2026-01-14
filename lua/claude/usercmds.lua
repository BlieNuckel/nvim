local claude = require "claude"
local usercmd = vim.api.nvim_create_user_command

usercmd("ClaudeSendDiagnostics", function(args)
  claude.send_diagnostics(args.args == "line" and "line" or "file")
end, {
  nargs = "?",
  complete = function()
    return { "file", "line" }
  end,
})

usercmd("ClaudeSelect", function(args)
  local id = tonumber(args.args)
  if id then
    claude.select(id)
    claude.focus(id)
  end
end, { nargs = 1 })

usercmd("ClaudeList", function()
  local list = claude.list()
  if #list == 0 then
    vim.notify("No Claude instances", vim.log.levels.INFO)
    return
  end

  local items = {}
  for _, inst in ipairs(list) do
    table.insert(items, {
      text = inst.name,
      id = inst.id,
      is_active = inst.is_active,
      needs_attention = inst.needs_attention,
    })
  end

  require("snacks").picker.select(items, {
    prompt = "Claude Instances",
    format_item = function(item)
      local marker = item.is_active and "* " or "  "
      local attention = item.needs_attention and " ⚠" or ""
      return marker .. item.text .. attention
    end,
  }, function(choice)
    if choice then
      claude.select(choice.id)
      claude.focus(choice.id)
      vim.cmd "startinsert"
    end
  end)
end, {})
