local conformConf = require "plugins.conform"
local lspconfigConf = require "plugins.lspconfig.init"
local treesitterConf = require "plugins.treesitter.init"
local surroundConf = require "plugins.surround.init"
local ufoConf = require "plugins.ufo.init"
local sessionConf = require "plugins.session.init"
local nvimtreeConf = require "plugins.nvimtree.init"
local glanceConf = require "plugins.glance.init"

return {
  conformConf,
  lspconfigConf,
  treesitterConf,
  surroundConf,
  ufoConf,
  sessionConf,
  nvimtreeConf,
  glanceConf,
  { import = "nvchad.blink.lazyspec" },
}
