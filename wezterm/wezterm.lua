local wezterm = require "wezterm"
local keybindings = require "keybindings"
local utils = require "utils"

utils.notify_reload()

return {
    font = wezterm.font "Source Code Pro for Powerline",
    font_size = 12.0,
    
    hide_tab_bar_if_only_one_tab = true,

    -- Don't accidentally select stuff when I click on a window and accidentally move a few pixels
    swallow_mouse_click_on_window_focus = true,
    
    -- Key bindings
    leader = { key = 'b', mods = 'CTRL' },
    keys = keybindings
}
