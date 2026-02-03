local dap = require "dap"
local repl = require "dap.repl"

local function copy_to_clipboard(value)
  vim.fn.setreg("+", value)
  vim.fn.setreg('"', value)
  vim.notify("Copied to clipboard", vim.log.levels.INFO)
end

local function evaluate_and_copy(expr)
  local session = dap.session()
  if not session then
    vim.notify("No active debug session", vim.log.levels.WARN)
    return
  end

  local wrapped = string.format("JSON.stringify(%s, null, 2)", expr)
  session:evaluate(wrapped, function(err, resp)
    if err then
      vim.notify("Evaluation error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    if resp and resp.result then
      local value = resp.result
      if value:sub(1, 1) == '"' and value:sub(-1) == '"' then
        value = value:sub(2, -2):gsub('\\"', '"'):gsub("\\n", "\n"):gsub("\\t", "\t")
      end
      copy_to_clipboard(value)
    end
  end, { context = "repl" })
end

repl.commands.custom_commands = vim.tbl_extend("force", repl.commands.custom_commands or {}, {
  [".copy"] = evaluate_and_copy,
})
