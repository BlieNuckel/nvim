return {
  root_dir = function(fname)
    local elm_root_map = {
      ["/Users/lasse.poulsen/Documents/Repos/ui"] = "/Users/lasse.poulsen/Documents/Repos/ui/docs",
    }

    for mapped_root, target_root in pairs(elm_root_map) do
      if fname:find(mapped_root, 1, true) == 1 then
        return target_root
      end
    end

    local util = require "lspconfig.util"
    return util.root_pattern "elm.json"(fname)
  end,
}
