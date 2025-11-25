return {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)

    local elm_root_map = {
      ["/Users/lasse.poulsen/Documents/Repos/ui"] = "/Users/lasse.poulsen/Documents/Repos/ui/docs",
      ["/Users/lasse.poulsen/Documents/Repos/connectmeto/elm/shared"] = "/Users/lasse.poulsen/Documents/Repos/connectmeto/elm/places",
    }

    for mapped_root, target_root in pairs(elm_root_map) do
      if fname:find(mapped_root, 1, true) == 1 then
        on_dir(target_root)
        return
      end
    end

    local root = vim.fs.root(bufnr, "elm.json")
    on_dir(root)
  end,
}
