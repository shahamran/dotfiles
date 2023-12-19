-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Appearance

config.color_scheme = 'Dracula (Official)'
local theme = wezterm.color.get_builtin_schemes()[config.color_scheme]

local accent = theme.brights[5]
local active_bg = accent
local inactive_bg = theme.background
local inactive_hover_bg = theme.ansi[1]
config.colors = {
  tab_bar = {
    inactive_tab_edge = theme.background,
    active_tab = {
      bg_color = active_bg,
      fg_color = theme.cursor_fg,
    },
    inactive_tab = {
      bg_color = inactive_bg,
      fg_color = theme.foreground,
    },
    inactive_tab_hover = {
      bg_color = inactive_hover_bg,
      fg_color = theme.foreground,
    },
    new_tab = {
      bg_color = inactive_bg,
      fg_color = theme.foreground,
    },
    new_tab_hover = {
      bg_color = inactive_hover_bg,
      fg_color = theme.foreground,
    },
  },
}
config.command_palette_bg_color = theme.ansi[1]
config.command_palette_fg_color = theme.brights[8]

config.window_frame = {
  font_size = 13,
  active_titlebar_bg = theme.background,
  -- inactive_titlebar_bg = theme.selection_bg,
}

config.window_padding = {
  left = 5,
  right = 5,
  bottom = 0,
  top = 5,  -- Don't render on title bar
}

config.tab_bar_at_bottom = true

wezterm.on('update-right-status', function(window, pane)
  local domain = pane:get_domain_name()
  local workspace = window:active_workspace()
  local right_padding = '   '
  local status = string.format('domain: %s - workspace: %s %s', domain, workspace, right_padding)
  local table = window:active_key_table()
  if table then
    status = string.format('table: %s - %s', table, status)
  end
  window:set_right_status(wezterm.format {
      { Background = { Color = theme.background } },
      { Foreground = { Color = theme.foreground } },
      { Attribute = { Italic = true } },
      { Text = status },
    })
end)

-- Use CTRL-Space as leader
config.leader = {
  key = ' ',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}

config.keys = {
  -- Disable quick-select on ctrl+shift+space
  {
    key = ' ',
    mods = 'CTRL|SHIFT',
    action = act.DisableDefaultAssignment,
  },
  -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'b', mods = 'ALT' },
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
  -- Rebind CMD-Left, CMD-Right as Home, End
  {
    key = 'LeftArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'Home' }
  },
  {
    key = 'RightArrow',
    mods = 'CMD',
    action = act.SendKey { key = 'End' }
  },
  -- Minimize / Maximize split pane
  {
    key = 'm',
    mods = 'CTRL',
    action = act.TogglePaneZoomState,
  },
  -- Regular tmux-like pane switching
  {
    key = 'h',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },
  -- Tmux-like splits
  {
    key = '|',
    mods = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '-',
    mods = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  { -- tmux-fingers-like mode
    key = ' ',
    mods = 'LEADER',
    action = act.QuickSelect,
  },

  -- CTRL+Space, followed by 'r' will put us in resize-pane
  -- mode until we cancel that mode.
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },

  -- Open launcher with Leader-s
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },

  {
    key = '[',
    mods = 'LEADER',
    action = act.ActivateCopyMode,
  },
}

config.key_tables = {
  -- Defines the keys that are active in our resize-pane mode.
  -- Since we're likely to want to make multiple adjustments,
  -- we made the activation one_shot=false. We therefore need
  -- to define a key assignment for getting out of this mode.
  -- 'resize_pane' here corresponds to the name='resize_pane' in
  -- the key assignments above.
  resize_pane = {
    { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 2 } },
    { key = 'h',          action = act.AdjustPaneSize { 'Left', 2 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 2 } },
    { key = 'l',          action = act.AdjustPaneSize { 'Right', 2 } },
    { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 2 } },
    { key = 'k',          action = act.AdjustPaneSize { 'Up', 2 } },
    { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 2 } },
    { key = 'j',          action = act.AdjustPaneSize { 'Down', 2 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape',     action = 'PopKeyTable' },
  },
}

config.unix_domains = {
  {
    name = 'unix',
  },
}

-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { 'connect', 'unix' }

-- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.enable_scroll_bar = true
config.font_size = 13
config.harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'}

config.window_close_confirmation = 'NeverPrompt'

return config
