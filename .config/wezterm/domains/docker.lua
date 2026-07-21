local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local container_var = "wezterm_docker_container"

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
    return nil, stderr
  end

  local inspect = { "docker", "container", "inspect" }
  for _, id in ipairs(wezterm.split_by_newlines(stdout)) do
    if id ~= "" then
      table.insert(inspect, id)
    end
  end

  if #inspect == 3 then
    return {}
  end

  success, stdout, stderr = wezterm.run_child_process(inspect)
  if not success then
    wezterm.log_warn("Could not inspect Docker containers: " .. (stderr or "unknown error"))
    return nil, stderr
  end

  local containers = decode_json(stdout)
  if type(containers) ~= "table" then
    wezterm.log_warn("Could not parse Docker container metadata")
    return nil, "Could not parse Docker container metadata"
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

local function command(container)
  local result = { "docker", "exec", "-it" }

  table.insert(result, "--env")
  table.insert(result, "WEZTERM_DOCKER_CONTAINER=" .. container.id)

  if container.user and container.user ~= "" then
    table.insert(result, "--user")
    table.insert(result, container.user)
  end

  table.insert(result, "--workdir")
  table.insert(result, container.cwd)
  table.insert(result, container.id)

  table.insert(result, "sh")
  table.insert(result, "-lc")
  table.insert(
    result,
    "encoded=$(printf '%s' \"$WEZTERM_DOCKER_CONTAINER\" | base64 | tr -d '\\n'); "
      .. "[ -z \"$encoded\" ] || printf '\\033]1337;SetUserVar="
      .. container_var
      .. "=%s\\007' \"$encoded\"; "
      .. 'for shell in zsh bash sh; do if command -v "$shell" >/dev/null 2>&1; then exec "$shell" -l; fi; done; exit 127'
  )

  return result
end

local function notify(window, message)
  window:toast_notification("Docker", message, 4000)
end

local function spawn_tab(window, pane, container)
  window:perform_action(
    act.SpawnCommandInNewTab({
      args = command(container),
      domain = { DomainName = "local" },
    }),
    pane
  )
end

local function split(window, pane, container, direction)
  local action = direction == "Right" and act.SplitHorizontal or act.SplitVertical
  window:perform_action(
    action({
      args = command(container),
      domain = { DomainName = "local" },
    }),
    pane
  )
end

local function container_for(pane)
  local id = pane:get_user_vars()[container_var]
  if type(id) ~= "string" or id == "" then
    return nil
  end

  local success, stdout, stderr = wezterm.run_child_process({
    "docker",
    "container",
    "inspect",
    id,
  })
  if not success then
    return nil, stderr
  end

  local containers = decode_json(stdout)
  local container = type(containers) == "table" and containers[1] or nil
  if not container or not (container.State or {}).Running then
    return nil, "コンテナは停止しています"
  end

  return describe(container)
end

function M.select(window, pane)
  local containers, err = list_containers()
  if not containers then
    notify(window, "一覧を取得できません: " .. (err or "unknown error"))
    return
  end

  if #containers == 0 then
    notify(window, "実行中のコンテナはありません")
    return
  end

  local choices = {}
  local by_id = {}
  for _, container in ipairs(containers) do
    by_id[container.id] = container
    table.insert(choices, {
      id = container.id,
      label = container.label,
    })
  end

  window:perform_action(
    act.InputSelector({
      action = wezterm.action_callback(function(inner_window, inner_pane, id)
        if id and by_id[id] then
          spawn_tab(inner_window, inner_pane, by_id[id])
        end
      end),
      choices = choices,
      fuzzy = true,
      title = "Docker containers",
    }),
    pane
  )
end

function M.spawn_tab(window, pane)
  local container, err = container_for(pane)
  if container then
    spawn_tab(window, pane, container)
    return
  end

  if err then
    notify(window, "コンテナを取得できません: " .. err)
    return
  end

  window:perform_action(act.SpawnTab("CurrentPaneDomain"), pane)
end

function M.split_horizontal(window, pane)
  local container, err = container_for(pane)
  if container then
    split(window, pane, container, "Right")
    return
  end

  if err then
    notify(window, "コンテナを取得できません: " .. err)
    return
  end

  window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
end

function M.split_vertical(window, pane)
  local container, err = container_for(pane)
  if container then
    split(window, pane, container, "Bottom")
    return
  end

  if err then
    notify(window, "コンテナを取得できません: " .. err)
    return
  end

  window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
end

return M
