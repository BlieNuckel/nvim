local conformConf = require "plugins.conform"
local treesitterConf = require "plugins.treesitter.init"
local surroundConf = require "plugins.surround.init"
local ufoConf = require "plugins.ufo.init"
local sessionConf = require "plugins.session.init"
local nvimtreeConf = require "plugins.nvimtree.init"
local glanceConf = require "plugins.glance.init"

return {
  conformConf,
  treesitterConf,
  surroundConf,
  ufoConf,
  sessionConf,
  nvimtreeConf,
  glanceConf,
  { import = "nvchad.blink.lazyspec" },
}
