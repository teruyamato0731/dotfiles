local wezterm = require("wezterm")
local act = wezterm.action
local docker = require("docker")

return {
  -- Ctrl+Shift+D: 起動中のDockerコンテナを選択
  {
    key = "d",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      docker.select(window, pane)
    end),
  },

  -- Ctrl+Shift+T: 新しいタブ
  {
    key = "t",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      docker.spawn_tab(window, pane)
    end),
  },

  -- Ctrl+Shift+G: lazygitを新しいタブで起動
  {
    key = "g",
    mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      docker.lazygit(window, pane)
    end),
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
    action = wezterm.action_callback(function(window, pane)
      docker.split_horizontal(window, pane)
    end),
  },

  -- Alt+Shift+Enter: 上下分割
  {
    key = "Enter",
    mods = "ALT|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      docker.split_vertical(window, pane)
    end),
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
  },

  -- Ctrl+Backspace: 単語削除
  {
    key = "Backspace",
    mods = "CTRL",
    action = wezterm.action.SendString("\x17"),
  },
  {
    key = "phys:Delete",
    mods = "CTRL",
    action = wezterm.action.SendString("\x1bd"),
  },
}
