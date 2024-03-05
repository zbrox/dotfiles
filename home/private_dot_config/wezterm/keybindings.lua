local wezterm = require "wezterm"

return {{
    key = 'r',
    mods = 'CMD',
    action = wezterm.action.ReloadConfiguration
}, {
    key = '|',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal {
        domain = 'CurrentPaneDomain'
    }
}, {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical {
        domain = 'CurrentPaneDomain'
    }
}, {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane {
        confirm = true
    }
}, {
    key = 'X',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentTab {
        confirm = true
    }
}, {
    key = 'p',
    mods = 'CMD',
    action = wezterm.action.QuickSelect
}}
