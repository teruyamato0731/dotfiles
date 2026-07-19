local wezterm = require("wezterm")

local M = {}

local function path_basename(path)
  return path:match("([^/]+)/?$") or path
end

local function inspect_devcontainer(id, local_folder)
  local success, stdout, stderr = wezterm.run_child_process({
    "docker",
    "container",
    "inspect",
    "--format",
    "{{.Config.User}}\n{{range .Mounts}}{{.Source}}\t{{.Destination}}\n{{end}}",
    id,
  })

  if not success then
    wezterm.log_warn(
      "Could not inspect Dev Container " .. id .. ": " .. (stderr or "unknown error")
    )
    return nil, nil
  end

  local user, mounts = stdout:match("^(.-)\n(.*)$")
  local workspace_folder

  for _, mount in ipairs(wezterm.split_by_newlines(mounts or "")) do
    local source, destination = mount:match("^(.-)\t(.*)$")
    if source == local_folder then
      workspace_folder = destination
      break
    end
  end

  return user, workspace_folder
end

local function list_devcontainers()
  local success, stdout, stderr = wezterm.run_child_process({
    "docker",
    "container",
    "ls",
    "--filter",
    "label=devcontainer.local_folder",
    "--format",
    "{{.ID}}\t{{.Label \"devcontainer.local_folder\"}}",
  })

  if not success then
    wezterm.log_warn(
      "Could not list running Dev Containers: " .. (stderr or "unknown error")
    )
    return {}
  end

  local containers = {}
  for _, line in ipairs(wezterm.split_by_newlines(stdout)) do
    local id, local_folder = line:match("^([^\t]+)\t(.+)$")
    if id and local_folder then
      local user, workspace_folder = inspect_devcontainer(id, local_folder)
      table.insert(containers, {
        id = id,
        local_folder = local_folder,
        user = user,
        workspace_folder = workspace_folder,
      })
    end
  end

  table.sort(containers, function(left, right)
    return left.local_folder < right.local_folder
  end)

  return containers
end

local function make_fixup(container)
  return function(cmd)
    local wrapped = { "docker", "exec", "-it" }

    if container.user and container.user ~= "" then
      table.insert(wrapped, "--user")
      table.insert(wrapped, container.user)
    end

    if container.workspace_folder then
      table.insert(wrapped, "--workdir")
      table.insert(wrapped, container.workspace_folder)
    end

    table.insert(wrapped, container.id)

    for _, arg in ipairs(cmd.args or { "/bin/bash", "-l" }) do
      table.insert(wrapped, arg)
    end

    cmd.args = wrapped
    -- The Docker workdir above is inside the container, not on the host.
    cmd.cwd = nil
    return cmd
  end
end

function M.domains()
  local exec_domains = {}

  for _, container in ipairs(list_devcontainers()) do
    table.insert(
      exec_domains,
      wezterm.exec_domain(
        "devcontainer:" .. container.id,
        make_fixup(container),
        "Dev Container: " .. path_basename(container.local_folder)
      )
    )
  end

  return exec_domains
end

return M
