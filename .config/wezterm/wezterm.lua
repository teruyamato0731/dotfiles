local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

config.initial_cols = 150
config.initial_rows = 40

-- ---------------------------------------------------------------------------
-- Dev Containers
-- ---------------------------------------------------------------------------

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
    "{{.ID}}\t{{.Names}}\t{{.Label \"devcontainer.local_folder\"}}",
  })

  if not success then
    wezterm.log_warn(
      "Could not list running Dev Containers: " .. (stderr or "unknown error")
    )
    return {}
  end

  local containers = {}
  for _, line in ipairs(wezterm.split_by_newlines(stdout)) do
    local id, name, local_folder = line:match("^([^\t]+)\t([^\t]+)\t(.+)$")
    if id and name and local_folder then
      local user, workspace_folder = inspect_devcontainer(id, local_folder)
      table.insert(containers, {
        id = id,
        name = name,
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

local function make_devcontainer_fixup(container)
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

local function compute_devcontainer_domains()
  local exec_domains = {}
  local containers = list_devcontainers()

  for _, container in ipairs(containers) do
    local domain_name = "devcontainer:" .. container.id
    local label = "Dev Container: " .. path_basename(container.local_folder)

    table.insert(
      exec_domains,
      wezterm.exec_domain(domain_name, make_devcontainer_fixup(container), label)
    )
  end

  local default_domain
  if #containers == 1 then
    default_domain = "devcontainer:" .. containers[1].id
  end

  return exec_domains, default_domain
end

local devcontainer_domains, devcontainer_default_domain = compute_devcontainer_domains()
config.exec_domains = devcontainer_domains

-- When there is exactly one running Dev Container, open WezTerm directly in it.
if devcontainer_default_domain then
  config.default_domain = devcontainer_default_domain
end

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ---------------------------------------------------------------------------
-- Font
-- ---------------------------------------------------------------------------

config.font = wezterm.font_with_fallback({
  {
    family = "Moralerspace Neon HW",
    weight = "Regular",
  },
})

config.font_size = 12.0
config.line_height = 1.1

-- ---------------------------------------------------------------------------
-- Appearance
-- ---------------------------------------------------------------------------

config.color_scheme = 'Humanoid dark (base16)'

config.colors = {
  split = "#89b4fa",
  scrollbar_thumb = "#7f849c",
}

config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

config.window_background_opacity = 1.0

config.window_padding = {
  left = 8,
  right = 12,
  top = 8,
  bottom = 8,
}

config.enable_scroll_bar = true
config.window_close_confirmation = "NeverPrompt"

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

-- ---------------------------------------------------------------------------
-- Terminal behavior
-- ---------------------------------------------------------------------------

config.scrollback_lines = 100000
config.audible_bell = "Disabled"

-- TERMは基本的にデフォルトのxterm-256colorのままにする
-- config.term = "xterm-256color"

-- ---------------------------------------------------------------------------
-- Cursor
-- ---------------------------------------------------------------------------

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- ---------------------------------------------------------------------------
-- Key bindings
-- ---------------------------------------------------------------------------

config.keys = {
  -- Ctrl+Shift+D: Dev Containerを選択
  {
    key = "d",
    mods = "CTRL|SHIFT",
    action = act.ShowLauncherArgs({ flags = "DOMAINS" }),
  },

  -- Ctrl+Shift+T: 新しいタブ
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = act.SpawnTab("CurrentPaneDomain"),
  },

  -- Ctrl+Shift+W: 現在のペインを閉じる
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = act.CloseCurrentPane({ confirm = false }),
  },

  -- Alt+Enter: 左右分割
  {
    key = "Enter",
    mods = "ALT",
    action = act.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },

  -- Alt+Shift+Enter: 上下分割
  {
    key = "Enter",
    mods = "ALT|SHIFT",
    action = act.SplitVertical({
      domain = "CurrentPaneDomain",
    }),
  },

  -- Alt+h/j/k/l: ペイン移動
  {
    key = "h",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "ALT",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },

  -- Ctrl+Shift+矢印: ペインサイズ変更
  {
    key = "LeftArrow",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "RightArrow",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Right", 5 }),
  },
  {
    key = "UpArrow",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Up", 3 }),
  },
  {
    key = "DownArrow",
    mods = "CTRL|SHIFT",
    action = act.AdjustPaneSize({ "Down", 3 }),
  },

  -- Alt+1〜9: タブ切り替え
  {
    key = "1",
    mods = "ALT",
    action = act.ActivateTab(0),
  },
  {
    key = "2",
    mods = "ALT",
    action = act.ActivateTab(1),
  },
  {
    key = "3",
    mods = "ALT",
    action = act.ActivateTab(2),
  },
  {
    key = "4",
    mods = "ALT",
    action = act.ActivateTab(3),
  },
  {
    key = "5",
    mods = "ALT",
    action = act.ActivateTab(4),
  },
  {
    key = "6",
    mods = "ALT",
    action = act.ActivateTab(5),
  },
  {
    key = "7",
    mods = "ALT",
    action = act.ActivateTab(6),
  },
  {
    key = "8",
    mods = "ALT",
    action = act.ActivateTab(7),
  },
  {
    key = "9",
    mods = "ALT",
    action = act.ActivateTab(8),
  }
}

return config
