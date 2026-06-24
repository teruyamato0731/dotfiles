--- @sync entry

local function notify(level, content)
  ya.notify {
    title = "git-root",
    content = content,
    timeout = 3,
    level = level,
  }
end

local function git_root(cwd)
  local handle = io.popen("git -C " .. ya.quote(tostring(cwd)) .. " rev-parse --show-toplevel 2>/dev/null")
  if not handle then
    return nil, "failed to execute git"
  end

  local root = handle:read("*l")
  local ok = handle:close()

  if root == nil or root == "" then
    if ok then
      return nil, "not inside a Git repository"
    end

    return nil, "failed to resolve Git root"
  end

  return root
end

local function entry()
  local root, err = git_root(cx.active.current.cwd)
  if root then
    ya.emit("cd", { root })
  elseif err then
    notify("warn", err)
  end
end

return { entry = entry }
