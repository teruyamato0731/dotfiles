local function read_line(command)
  local handle = io.popen(command)
  if not handle then
    return nil
  end

  local line = handle:read("*l")
  handle:close()

  if line == nil or line == "" then
    return nil
  end

  return line
end

local function git_info()
  if ya.target_family() ~= "unix" then
    return nil
  end

  local cwd = tostring(cx.active.current.cwd)
  local quoted_cwd = ya.quote(cwd)
  local branch = read_line("git -C " .. quoted_cwd .. " branch --show-current 2>/dev/null")

  if not branch then
    branch = read_line("git -C " .. quoted_cwd .. " rev-parse --short HEAD 2>/dev/null")
  end

  if not branch then
    return nil
  end

  return {
    branch = branch,
  }
end

Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ""
  end

  return ui.Span(ya.user_name() .. " ➜ "):fg("green")
end, 500, Header.LEFT)

Header:children_add(function()
  if ya.target_family() ~= "unix" then
    return ""
  end

  local git = git_info()
  if not git then
    return ""
  end

  return ui.Span(" (" .. git.branch .. ") "):fg("cyan")
end, 2000, Header.LEFT)

Status:children_add(function()
  local h = cx.active.current.hovered
  if not h or ya.target_family() ~= "unix" then
    return ""
  end

  return ui.Line {
    ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
    ":",
    ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
    " ",
  }
end, 500, Status.RIGHT)
