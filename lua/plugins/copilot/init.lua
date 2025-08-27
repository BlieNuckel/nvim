return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      tootls = "copilot",
      resources = "buffers:all",
      sticky = {},
      mappings = {
        complete = {
          insert = "<C-c>",
        },
        close = {
          insert = "<C-q>",
        },
        reset = {
          normal = "",
          insert = "",
        },
      },
      insert_at_end = true,
      auto_insert_mode = true,
    },
    -- See Commands section for default commands if you want to lazy load on them
    event = "VeryLazy",
  },
}
