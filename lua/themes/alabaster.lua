-- @type Base46Table
local M = {}

M.base_30 = {
  deep_black = "#000000", -- function calls
  white = "#000000", -- main text
  darker_black = "#ffffff", -- nvim tree & term bg
  black = "#FFFfff", --  nvim bg and nvim tree curr highlight
  black2 = "#ECEFF1", -- line highlight and fzf-lua "h"
  one_bg = "#ebebeb", -- status line dir icon fg
  one_bg2 = "#e0e0e0", -- unknown
  one_bg3 = "#d4d4d4", -- instances of current word under cursor bg
  grey = "#aaaaaa", -- gutter (line numbers) fg, status line path fg
  grey_fg = "#b5b5b5", -- comments
  grey_fg2 = "#a3a3a3", -- unknown
  light_grey = "#848484", -- status line branch name fg
  faded_grey = "#8497a0", -- strings, obkects (? "M")
  red = "#EF5350", -- errors and status line dir icon bg, git changed fg (nvim tree), root dir fg (nvim tree)
  tintred = "#BF616A",
  baby_pink = "#b55dc4",
  pink = "#AB47BC",
  line = "#e0e0e0", -- for lines like vertsplit
  green = "#66BB6A", -- additions git fg and bg, scroll status fg (status line), scroll status icon bg (status line)
  vibrant_green = "#75c279",
  nord_blue = "#42A5F5", -- normal mode (status line), LSP fg (status line)
  blue = "#42A5F5", -- file icons (nvim tree), terminal border, lsp lookup border
  yellow = "#E2C12F", -- starred files (nvim tree), snack warning border
  sun = "#E2C12F",
  purple = "#673AB7", -- variables, properties, status line warnings
  dark_purple = "#673AB7", -- insert mode (status line)
  teal = "#008080",
  orange = "#FF6F00",
  cream = "#e09680",
  clay = "#D08770",
  cyan = "#26C6DA",
  statusline_bg = "#ECEFF1",
  lightbg = "#e0e0e0", -- bg for status line path, root dir, and page progress
  pmenu_bg = "#673AB7", -- popup menu selected item bg
  folder_bg = "#4C566A",
}

M.base_16 = {
  base00 = M.base_30.black,
  base01 = M.base_30.black2,
  base02 = M.base_30.one_bg,
  base03 = M.base_30.grey,
  base04 = M.base_30.grey_fg,
  base05 = M.base_30.white,
  base06 = M.base_30.folder_bg,
  base07 = M.base_30.deep_black,
  base08 = M.base_30.deep_black,
  base09 = M.base_30.deep_black,
  base0A = M.base_30.deep_black,
  base0B = M.base_30.vibrant_green,
  base0C = M.base_30.deep_black,
  base0D = M.base_30.deep_black,
  base0E = M.base_30.deep_black,
  base0F = M.base_30.deep_black,
}

local hl = {
  const = { fg = "#6E3DC2", bg = "#F1ECF9" },
  string = { fg = "#59B55D", bg = "#EDF7ED" },
  comment = { fg = "#AD8D00", bg = "#FFFAE5" },
  type = { fg = "#007676", bg = "#E5F5F5" },
  keyword = { fg = "#7a7a7a" },
  definition = { fg = "#325CC0", bg = "#E8EEF9" },
  attribute = { fg = "#E65100", bg = "#FFF3E0" },
}

M.polish_hl = {
  treesitter = {
    -- Constants
    ["@constant"] = hl.const,
    ["@constant.builtin"] = hl.const,
    ["@constant.macro"] = hl.const,
    ["@boolean"] = hl.const,

    -- Strings and literals
    ["@string"] = hl.string,
    ["@string.regexp"] = hl.string,
    ["@string.escape"] = hl.string,
    ["@string.special"] = hl.string,
    ["@character"] = hl.string,
    ["@number"] = hl.string,
    ["@number.float"] = hl.string,

    -- Definitions (via custom TreeSitter queries)
    ["@type.definition"] = hl.type,
    ["@function.definition"] = hl.definition,
    ["@variable.definition"] = hl.definition,

    -- Keywords (lighter gray to reduce visual weight)
    ["@keyword"] = hl.keyword,
    ["@keyword.function"] = hl.keyword,
    ["@keyword.operator"] = hl.keyword,
    ["@keyword.return"] = hl.keyword,
    ["@keyword.conditional"] = hl.keyword,
    ["@keyword.repeat"] = hl.keyword,
    ["@keyword.import"] = hl.keyword,
    ["@keyword.exception"] = hl.keyword,

    -- Attributes/decorators
    ["@attribute"] = hl.attribute,
    ["@attribute.builtin"] = hl.attribute,

    -- Comments
    ["@comment"] = hl.comment,
    ["@comment.documentation"] = hl.comment,
    ["@comment.todo"] = { fg = "#E65100", bg = "#FFF3E0", bold = true },
    ["@comment.note"] = { fg = "#2597F3", bg = "#E7F4FE", bold = true },
    ["@comment.warning"] = { fg = "#AD8D00", bg = "#FFFAE5", bold = true },
    ["@comment.error"] = { fg = "#C62828", bg = "#FFEBEE", bold = true },

    -- Keep YAML properties plain
    ["@property.yaml"] = { fg = M.base_30.deep_black },
  },

  lsp = {
    -- LSP semantic token modifiers for definitions (the key feature!)
    ["@lsp.mod.declaration"] = hl.definition,
    ["@lsp.mod.definition"] = hl.definition,

    -- Function/method definitions
    ["@lsp.typemod.function.declaration"] = hl.definition,
    ["@lsp.typemod.function.definition"] = hl.definition,
    ["@lsp.typemod.method.declaration"] = hl.definition,
    ["@lsp.typemod.method.definition"] = hl.definition,

    -- Type definitions (teal)
    ["@lsp.typemod.type.declaration"] = hl.type,
    ["@lsp.typemod.class.declaration"] = hl.type,
    ["@lsp.typemod.struct.declaration"] = hl.type,
    ["@lsp.typemod.interface.declaration"] = hl.type,
    ["@lsp.typemod.enum.declaration"] = hl.type,

    -- Variable/parameter definitions
    ["@lsp.typemod.variable.declaration"] = hl.definition,
    ["@lsp.typemod.parameter.declaration"] = hl.definition,

    -- Readonly/static modifiers (subtle italic)
    ["@lsp.mod.readonly"] = { italic = true },
    ["@lsp.mod.static"] = { italic = true },
  },

  nvimtree = {
    NvimTreeCursorLine = { bg = M.base_30.one_bg },
  },
}

M.type = "light"

M = require("base46").override_theme(M, "alabaster")

return M
