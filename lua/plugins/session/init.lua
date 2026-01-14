return {
  "rmagatti/auto-session",
  lazy = false,
  opts = {
    supressed_dirs = { "~/", "~/Downloads", "/" },
    session_lens = {
      picker = "fzf",
    },
    pre_save_cmds = {
      function()
        require("claude").cleanup()
      end,
    },
  },
}
