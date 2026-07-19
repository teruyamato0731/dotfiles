local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local devcontainer = require("domains.devcontainer")

local config = wezterm.config_builder()

config.initial_cols = 150
config.initial_rows = 40

config.exec_domains = devcontainer.domains()

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
  -- Ctrl+Shift+D: Dev Container一覧を更新して選択
  {
    key = "d",
    mods = "CTRL|SHIFT",
    action = devcontainer.launcher_action(),
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
