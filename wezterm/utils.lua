local wezterm = require "wezterm"

local M = {}

M.notify_reload = function()
    wezterm.on("window-config-reloaded", function(window, pane)
        window:toast_notification("wezterm", "конфигурацията е презаредена", nil, 4000)
    end)
end

return M
