local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrainsMono Nerd Font Propo")
config.font_size = 14

-- disable tab bar
config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.75

if wezterm.target_triple:find("darwin") then
	config.macos_window_background_blur = 10
end

config.default_prog = { '/opt/homebrew/bin/zellij', '-l', 'welcome' }

return config
