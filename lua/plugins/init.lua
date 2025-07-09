local conformConf = require "plugins.conform"
local treesitterConf = require "plugins.treesitter.init"
local surroundConf = require "plugins.surround.init"
local ufoConf = require "plugins.ufo.init"
local sessionConf = require "plugins.session.init"
local nvimtreeConf = require "plugins.nvimtree.init"
local glanceConf = require "plugins.glance.init"
local blamerConf = require "plugins.blamer.init"
local kulalaConf = require "plugins.kulala.init"
local dapConf = require "plugins.dap.init"
local copilotConf = require "plugins.copilot.init"

return {
  conformConf,
  treesitterConf,
  surroundConf,
  ufoConf,
  sessionConf,
  nvimtreeConf,
  glanceConf,
  blamerConf,
  kulalaConf,
  dapConf,
  copilotConf,
  { import = "nvchad.blink.lazyspec" },
}
