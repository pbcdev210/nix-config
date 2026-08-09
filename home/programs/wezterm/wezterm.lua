local wezterm = require('wezterm') ---@type Wezterm
local config = wezterm.config_builder()

local act = wezterm.action

config.keys = {
  {
    key = "a",
    mods = "ALT|SHIFT",
    action = act.SpawnTab 'CurrentPaneDomain'
  },

  {
    key = "s",
    mods = "ALT|SHIFT",
    action = act.CloseCurrentTab { confirm = true, }
  }
}

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "ALT",
    action = act.ActivateTab(i - 1),
  })
end

return config
