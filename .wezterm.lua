local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.font_size = 15.0
config.color_scheme = 'Catppuccin Mocha'
config.use_fancy_tab_bar = false
config.tab_max_width = 999   -- don't let the default cap truncate our padding

wezterm.on('format-tab-title', function(tab, tabs, panes, conf, hover, max_width)
  -- full tab width in cells — unaffected by pane splits. pcall takes the
  -- method directly rather than wrapping it in a closure: this runs per tab
  -- per repaint, and a fresh closure each time is pure GC churn.
  -- NB: keep the pcall on its own statement. `local ok, size = mux_tab and
  -- pcall(...)` looks equivalent but is not -- `and` adjusts its operand to a
  -- single value, so size would silently be nil and cols would always be 80.
  local cols = 80
  local mux_tab = wezterm.mux.get_tab(tab.tab_id)
  if mux_tab then
    local ok, size = pcall(mux_tab.get_size, mux_tab)
    if ok and size and size.cols then
      cols = size.cols
    end
  end

  -- cols rarely divides evenly, and flooring would drop the remainder from
  -- every tab at once -- a right-edge gap that grows with the tab count. Hand
  -- the leftover cells out one apiece to the leftmost tabs instead.
  local base = math.floor(cols / #tabs)
  local extra = cols % #tabs
  local slot = base + (tab.tab_index < extra and 1 or 0)

  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  title = string.format('%d: %s', tab.tab_index + 1, title)

  -- truncate if too long, then center-pad to fill the slot. Widths are in
  -- cells, not bytes: '#title' would over-count any non-ASCII title.
  local avail = slot - 2
  local width = wezterm.column_width(title)
  if width > avail then
    title = wezterm.truncate_right(title, avail - 1) .. '…'
    width = wezterm.column_width(title)
  end
  local pad = slot - width
  local left = math.floor(pad / 2)
  local right = pad - left

  return string.rep(' ', left) .. title .. string.rep(' ', right)
end)

config.keys = {
  -- Cmd+C with no selection would copy "" and wipe the clipboard. Only copy
  -- when there is something selected; otherwise leave the clipboard alone.
  {
    key = 'c',
    mods = 'CMD',
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and sel ~= '' then
        window:perform_action(act.CopyTo 'ClipboardAndPrimarySelection', pane)
      end
    end),
  },

  -- Splits (iTerm-style)
  { key = 'd', mods = 'CMD',       action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical   { domain = 'CurrentPaneDomain' } },

  -- macOS line movement: WezTerm sends nothing for Cmd+Arrow by default.
  -- zsh binds the Home/End sequences in ~/.zshrc.
  { key = 'LeftArrow',  mods = 'CMD', action = act.SendKey { key = 'Home' } },
  { key = 'RightArrow', mods = 'CMD', action = act.SendKey { key = 'End' } },

  -- Reorder tabs: move current tab left/right
  { key = 'LeftArrow',  mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },

  -- Navigate panes
  { key = 'LeftArrow',  mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },

  -- Zoom pane fullscreen (great for focusing one CC session)
  { key = 'Enter', mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },

  -- Close pane (asks confirmation if something's running)
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },

  -- Rename tab: opens a prompt, type name, Enter
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = act.PromptInputLine {
      description = 'Rename tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

-- WezTerm has no Cmd+click link binding of its own (its default is a plain
-- left click). TUIs like Claude Code turn on mouse reporting, which swallows
-- plain clicks, so register the binding for both reporting states.
config.mouse_bindings = {}
for _, reporting in ipairs { true, false } do
  table.insert(config.mouse_bindings, {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.OpenLinkAtMouseCursor,
    mouse_reporting = reporting,
    alt_screen = 'Any',
  })
  -- swallow the press half so the app never sees it as a click
  table.insert(config.mouse_bindings, {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.Nop,
    mouse_reporting = reporting,
    alt_screen = 'Any',
  })
end

-- WezTerm opens a link/file/mailto on a left release with NO modifier, and on
-- SHIFT and SHIFT|ALT as well -- all three default to
-- CompleteSelectionOrOpenLinkAtMouseCursor (see `wezterm show-keys`).
-- Downgrade every one of them to selection-only, keeping each default's own
-- clipboard destination, so Cmd really is the only way to open something.
for _, sel in ipairs {
  { mods = 'NONE',      dest = 'ClipboardAndPrimarySelection' },
  { mods = 'SHIFT',     dest = 'ClipboardAndPrimarySelection' },
  { mods = 'SHIFT|ALT', dest = 'PrimarySelection' },
} do
  table.insert(config.mouse_bindings, {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = sel.mods,
    action = act.CompleteSelection(sel.dest),
    mouse_reporting = false,
    alt_screen = 'Any',
  })
end

-- Clickable file:line:col from tool output (eslint -f unix, tsc, jest stack
-- traces). Only absolute paths work: hyperlink_rules are matched per line and
-- the format string can only expand capture groups, so there is no cwd to
-- resolve a relative "./components/Foo.tsx" against.
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- [==[ ]==] because the character class contains "]]", which would close a
-- plain [[ ]] long string early
local PATH = [==[(/[^\s:'"()\[\]]+\.[A-Za-z0-9]+)]==]

-- path:line:col before path:line, else the shorter rule eats the match first
table.insert(config.hyperlink_rules, {
  regex = PATH .. [[:(\d+):(\d+)]],
  format = 'vscode://file$1:$2:$3',
})
table.insert(config.hyperlink_rules, {
  regex = PATH .. [[:(\d+)]],
  format = 'vscode://file$1:$2',
})
-- tsc / older toolchains: path(line,col)
table.insert(config.hyperlink_rules, {
  regex = PATH .. [[\((\d+),(\d+)\)]],
  format = 'vscode://file$1:$2:$3',
})

return config
