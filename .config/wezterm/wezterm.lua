local wezterm = require("wezterm")
local mux = wezterm.mux

local config = wezterm.config_builder()

config.initial_cols = 150
config.initial_rows = 40

-- devcontainer へ SSH_AUTH_SOCK が継承されて、寿命切れになる問題の回避
config.mux_enable_ssh_agent = false

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

-- Kitty Keyboard Protocol を有効化
config.enable_kitty_keyboard = true

-- ---------------------------------------------------------------------------
-- Cursor
-- ---------------------------------------------------------------------------

config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- ---------------------------------------------------------------------------
-- Key bindings
-- ---------------------------------------------------------------------------

config.keys = require("keybindings")

return config
