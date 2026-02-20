local M = {}

function M.picker(create_instance)
  local output = vim.fn.system "git worktree list --porcelain"
  if vim.v.shell_error ~= 0 then
    vim.notify("Not in a git repository", vim.log.levels.WARN)
    return
  end

  local worktrees = {}
  local worktree_branches = {}
  local current = {}
  for line in output:gmatch "[^\n]+" do
    if line:match "^worktree " then
      current.path = line:sub(10)
    elseif line:match "^branch " then
      current.branch = line:sub(8):match "[^/]+$"
    elseif line == "" and current.path then
      table.insert(worktrees, current)
      if current.branch then
        worktree_branches[current.branch] = true
      end
      current = {}
    end
  end
  if current.path then
    table.insert(worktrees, current)
    if current.branch then
      worktree_branches[current.branch] = true
    end
  end

  local branches = {}
  local branch_output = vim.fn.system "git branch --format=%(refname:short)"
  if vim.v.shell_error == 0 then
    for branch in branch_output:gmatch "[^\n]+" do
      if not worktree_branches[branch] then
        table.insert(branches, { branch_only = true, branch = branch })
      end
    end
  end

  local items = { { none = true } }
  vim.list_extend(items, worktrees)
  vim.list_extend(items, branches)
  table.insert(items, { new = true })

  require("snacks").picker.select(items, {
    prompt = "New Claude instance",
    format_item = function(item)
      if item.none then
        return "Current directory"
      end
      if item.new then
        return "+ Create new branch..."
      end
      if item.branch_only then
        return "⎇ " .. item.branch
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
    elseif choice.branch_only then
      M.create_for_branch(choice.branch, create_instance)
    else
      create_instance { name = choice.branch or "detached", cwd = choice.path }
    end
  end)
end

function M.create_for_branch(branch, create_instance)
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
