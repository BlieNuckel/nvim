local M = {}

function M.picker(create_instance)
  local output = vim.fn.system "git worktree list --porcelain"
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  local worktrees = {}
  local current = {}
  for line in output:gmatch "[^\n]+" do
    if line:match "^worktree " then
      current.path = line:sub(10)
    elseif line:match "^branch " then
      current.branch = line:sub(8):match "[^/]+$"
    elseif line == "" and current.path then
      table.insert(worktrees, current)
      current = {}
    end
  end
  if current.path then
    table.insert(worktrees, current)
  end

  local worktree_branches = {}
  for _, wt in ipairs(worktrees) do
    if wt.branch then
      worktree_branches[wt.branch] = true
    end
  end

  local branch_output = vim.fn.system "git branch --format='%(refname:short)'"
  local local_branches = {}
  for line in branch_output:gmatch "[^\n]+" do
    if not worktree_branches[line] then
      table.insert(local_branches, { branch = line, local_branch = true })
    end
  end

  table.insert(worktrees, 1, { none = true })
  for _, b in ipairs(local_branches) do
    table.insert(worktrees, b)
  end
  table.insert(worktrees, { new = true })

  require("snacks").picker.select(worktrees, {
    prompt = "Worktree",
    format_item = function(item)
      if item.none then
        return "None (current directory)"
      end
      if item.new then
        return "+ Create new worktree..."
      end
      if item.local_branch then
        return item.branch .. " (local branch)"
      end
      return (item.branch or "detached") .. " → " .. item.path
    end,
  }, function(choice)
    if not choice then
      return
    end
    if choice.none then
      create_instance {}
    elseif choice.new then
      M.create(create_instance)
    elseif choice.local_branch then
      M.create_for_branch(create_instance, choice.branch)
    else
      create_instance { name = choice.branch or "detached", cwd = choice.path }
    end
  end)
end

function M.create_for_branch(create_instance, branch)
  local root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  local parent = vim.fn.fnamemodify(root, ":h")
  local path = parent .. "/" .. branch

  local result = vim.fn.system(string.format("git worktree add %s %s", path, branch))
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
    return
  end

  create_instance { name = branch, cwd = path }
end

function M.create(create_instance)
  vim.ui.input({ prompt = "Branch name: " }, function(branch)
    if not branch or branch == "" then
      return
    end

    local root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
    local parent = vim.fn.fnamemodify(root, ":h")
    local path = parent .. "/" .. branch

    local result = vim.fn.system(string.format("git worktree add -b %s %s", branch, path))
    if vim.v.shell_error ~= 0 then
      result = vim.fn.system(string.format("git worktree add %s %s", path, branch))
    end

    if vim.v.shell_error ~= 0 then
      vim.notify("Failed to create worktree: " .. result, vim.log.levels.ERROR)
      return
    end

    create_instance { name = branch, cwd = path }
  end)
end

return M
