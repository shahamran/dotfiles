-- Pull in the wezterm API
local wez = require 'wezterm'
local act = wez.action
local nf = wez.nerdfonts

local config = {}
if wez.config_builder then
  config = wez.config_builder()
end

-- General appearance

-- config.window_decorations = 'INTEGRATED_BUTTONS | RESIZE'
config.enable_scroll_bar = true
config.font_size = 13
config.harfbuzz_features = {'calt=0', 'clig=0', 'liga=0'}
config.window_close_confirmation = 'NeverPrompt'
config.color_scheme = 'Dracula (Official)'

local theme = wez.color.get_builtin_schemes()[config.color_scheme]
local gray = theme.scrollbar_thumb or '#44475a'
local white = theme.foreground
local black = theme.ansi[1]
local accent = theme.brights[5]
local active = theme.brights[1]
local strong = theme.brights[6]

config.command_palette_bg_color = black
config.command_palette_fg_color = white
config.command_palette_rows = 14

-- Configure tab bar and status line

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.colors = {
  tab_bar = {
    background = gray,
    new_tab = {
      bg_color = gray,
      fg_color = white,
    },
    new_tab_hover = {
      bg_color = strong,
      fg_color = gray,
    },
  }
}

config.tab_bar_style = {
  new_tab_hover = wez.format {
    { Background = { Color = strong } },
    { Foreground = { Color = gray } },
    { Text = nf.ple_lower_left_triangle },
    { Text = '+' },
    { Text = nf.ple_upper_right_triangle },
  },
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wez.on(
  'format-tab-title',
  function (tab, tabs, panes, config, hover, max_width)
    local background = gray
    local foreground = white
    if tab.is_active then
      background = active
    elseif hover then
      background = strong
      foreground = gray
    end
    local edge_bg = gray
    local edge_fg = background
    local title = tab_title(tab)
    -- Ensure enough space for separators and spaces
    title = wez.truncate_right(title, max_width - 4)
    -- Each tab has this powerline diagonal effect: \ tab \
    return {
      { Background = { Color = edge_bg } },
      { Foreground = { Color = edge_fg } },
      { Text = nf.ple_upper_right_triangle },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = ' ' .. title .. ' ' },
      { Background = { Color = edge_bg } },
      { Foreground = { Color = edge_fg } },
      { Text = nf.ple_lower_left_triangle },
    }
  end
)

wez.on('update-status', function(window, pane)
  -- Draw current workspace on the left
  local workspace = window:active_workspace()
  local left_bg = accent
  local left_fg = gray
  -- Change color if leader is active
  if window:leader_is_active() then
    left_bg = theme.brights[7]
  end
  local left_status = {
    { Background = { Color = left_bg } },
    { Foreground = { Color = left_fg } },
    { Text = ' ' .. workspace .. ' ' },
    { Text = nf.ple_upper_right_triangle },
  }
  window:set_left_status(wez.format(left_status))

  local elements = {}

  -- Add the given text to the right status line, with a nice
  -- / <text> / effect.
  local function push(text, is_last)
    elements[#elements+1] = { Background = { Color = active } }
    elements[#elements+1] = { Foreground = { Color = gray } }
    elements[#elements+1] = { Text = nf.ple_upper_left_triangle }
    elements[#elements+1] = { Foreground = { Color = white } }
    elements[#elements+1] = { Text = ' ' .. text .. ' ' }
    if not is_last then
      elements[#elements+1] = { Foreground = { Color = gray } }
      elements[#elements+1] = { Text = nf.ple_lower_right_triangle }
    end
  end

  local mode = window:active_key_table()
  if mode then
    push(mode, false)
  end

  local cells = {
    wez.strftime('%Y-%m-%d %H:%M'),
    pane:get_domain_name(),
  }
  for i=1,#cells do
    push(cells[i], i == #cells)
  end

  window:set_right_status(wez.format(elements))
end)

-- Key bindings

-- Use CTRL-Space as leader
config.leader = {
  key = ' ',
  mods = 'CTRL',
  timeout_milliseconds = 3000,
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
config.default_gui_startup_args = { 'connect', 'unix' }

return config
