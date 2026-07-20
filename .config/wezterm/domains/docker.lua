local wezterm = require("wezterm")

local M = {}

local shell_fallback = {
  "sh",
  "-lc",
  'for shell in zsh bash sh; do if command -v "$shell" >/dev/null 2>&1; then exec "$shell" -l; fi; done; exit 127',
}

local function basename(path)
  return path:match("([^/]+)/?$") or path
end

local function absolute_path(path)
  if type(path) == "string" and path:sub(1, 1) == "/" then
    return path
  end
end

local function decode_json(value)
  if not value or value == "" then
    return nil
  end

  local success, decoded = pcall(wezterm.json_parse, value)
  if success then
    return decoded
  end
end

local function merge_metadata(metadata)
  if type(metadata) ~= "table" then
    return {}
  end

  if metadata[1] == nil then
    return metadata
  end

  local merged = {}
  for _, entry in ipairs(metadata) do
    if type(entry) == "table" then
      for key, value in pairs(entry) do
        merged[key] = value
      end
    end
  end

  return merged
end

local function devcontainer_info(container)
  local labels = (container.Config or {}).Labels or {}
  local local_folder = labels["devcontainer.local_folder"]
  if not local_folder then
    return nil
  end

  local metadata = merge_metadata(decode_json(labels["devcontainer.metadata"]))

  local cwd = absolute_path(metadata.workspaceFolder)
  if not cwd then
    for _, mount in ipairs(container.Mounts or {}) do
      if mount.Source == local_folder then
        cwd = absolute_path(mount.Destination)
        break
      end
    end
  end

  return {
    cwd = cwd,
    name = basename(local_folder),
    user = type(metadata.remoteUser) == "string" and metadata.remoteUser or nil,
  }
end

local function describe(container)
  local config = container.Config or {}
  local labels = config.Labels or {}
  local name = (container.Name or container.Id):gsub("^/", "")
  local devcontainer = devcontainer_info(container)
  local cwd = (devcontainer and devcontainer.cwd) or absolute_path(config.WorkingDir) or "/"
  local label

  if devcontainer then
    label = "Dev Container: " .. devcontainer.name
  elseif labels["com.docker.compose.project"] and labels["com.docker.compose.service"] then
    label = "Compose: "
      .. labels["com.docker.compose.project"]
      .. "/"
      .. labels["com.docker.compose.service"]
  else
    label = "Docker: " .. name .. " (" .. (config.Image or "unknown") .. ")"
  end

  return {
    cwd = cwd,
    id = container.Id,
    label = label,
    name = name,
    user = devcontainer and devcontainer.user,
  }
end

local function list_containers()
  local success, stdout, stderr = wezterm.run_child_process({
    "docker",
    "container",
    "ls",
    "-q",
  })
  if not success then
    wezterm.log_warn("Could not list Docker containers: " .. (stderr or "unknown error"))
    return {}
  end

  local inspect = { "docker", "container", "inspect" }
  for _, id in ipairs(wezterm.split_by_newlines(stdout)) do
    table.insert(inspect, id)
  end

  if #inspect == 3 then
    return {}
  end

  success, stdout, stderr = wezterm.run_child_process(inspect)
  if not success then
    wezterm.log_warn("Could not inspect Docker containers: " .. (stderr or "unknown error"))
    return {}
  end

  local containers = decode_json(stdout)
  if type(containers) ~= "table" then
    wezterm.log_warn("Could not parse Docker container metadata")
    return {}
  end

  local result = {}
  for _, container in ipairs(containers) do
    if container.State and container.State.Running then
      table.insert(result, describe(container))
    end
  end

  table.sort(result, function(left, right)
    return left.label < right.label
  end)

  return result
end

local function make_fixup(container)
  return function(cmd)
    local wrapped = { "docker", "exec", "-it" }

    if container.user and container.user ~= "" then
      table.insert(wrapped, "--user")
      table.insert(wrapped, container.user)
    end

    table.insert(wrapped, "--workdir")
    table.insert(wrapped, container.cwd)
    table.insert(wrapped, container.id)

    for _, arg in ipairs(cmd.args or shell_fallback) do
      table.insert(wrapped, arg)
    end

    cmd.args = wrapped
    cmd.cwd = nil
    return cmd
  end
end

function M.domains()
  local domains = {}

  for _, container in ipairs(list_containers()) do
    table.insert(
      domains,
      wezterm.exec_domain(
        "docker:" .. container.name,
        make_fixup(container),
        container.label
      )
    )
  end

  return domains
end

return M
