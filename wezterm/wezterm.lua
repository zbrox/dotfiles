local wezterm = require "wezterm"

return {
    font = wezterm.font "Source Code Pro for Powerline",
    font_size = 12.0,
    
    hide_tab_bar_if_only_one_tab = true,

    -- Don't accidentally select stuff when I click on a window and accidentally move a few pixels
    swallow_mouse_click_on_window_focus = true,
    
    -- Key bindings
    leader = { key = 'b', mods = 'CTRL' },
    keys = {
        {
            key = 'r',
            mods = 'CMD',
            action = wezterm.action.ReloadConfiguration,
        },
        {
            key = '|',
            mods = 'LEADER',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        {
            key = '-',
            mods = 'LEADER',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'x',
            mods = 'LEADER',
            action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
            key = 'X',
            mods = 'LEADER',
            action = wezterm.action.CloseCurrentTab { confirm = true },
        },
    }
}
