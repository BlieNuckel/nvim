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

  session:evaluate(expr, function(err, resp)
    if err then
      vim.notify("Evaluation error: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    if resp and resp.result then
      copy_to_clipboard(resp.result)
    end
  end, { context = "clipboard" })
end

repl.commands = vim.tbl_extend("force", repl.commands or {}, {
  [".copy"] = evaluate_and_copy,
  copy = function(text)
    local inner = text:match "^copy%s*%((.+)%)%s*$"
    if inner then
      evaluate_and_copy(inner)
    else
      evaluate_and_copy(text)
    end
  end,
})
