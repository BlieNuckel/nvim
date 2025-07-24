local usercmd = vim.api.nvim_create_user_command

usercmd("BufCloseAll", function()
  vim.cmd "%bd!"
  vim.cmd "NvimTreeOpen"
end, {})

usercmd("BufCloseOthers", function()
  vim.cmd "%bd!|e#"
  vim.cmd "NvimTreeOpen"
end, {})
