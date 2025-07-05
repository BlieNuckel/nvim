local usercmd = vim.api.nvim_create_user_command

usercmd("BufCloseAll", "%bd", {})
