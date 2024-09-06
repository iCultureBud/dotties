local wezterm = require('wezterm')
local act = wezterm.action

return {
	window_decorations = "RESIZE",
	check_for_updates = false,
	window_close_confirmation = 'NeverPrompt',
	hide_tab_bar_if_only_one_tab = true,
	font_size = 19,
	window_background_opacity = .85,
	macos_window_background_blur = 80,
	native_macos_fullscreen_mode = false,
	color_scheme = 'nordfox',
	-- color_scheme = 'dawnfox',
	font = wezterm.font_with_fallback {
		'JetBrainsMono Nerd Font Mono',
		'FiraCode Nerd Font Mono',
	},
	window_frame = {
		font = wezterm.font('JetBrainsMono Nerd Font Mono'),
		active_titlebar_bg = '#303446',
		inactive_titlebar_bg = '#232634',
	},
	keys = {
		{ key = 'K', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-2) },
		{ key = 'J', mods = 'CTRL|SHIFT', action = act.ScrollByLine(2) },
		{ key = 'F', mods = 'CMD|SHIFT', action = wezterm.action.ToggleFullScreen },
	},
	colors = {
		tab_bar = {
			background = '#303446',
			active_tab = {
				bg_color = '#F4B8E4',
				fg_color = '#51576D',
			},
			inactive_tab = {
				bg_color = '#232634',
				fg_color = '#626880',
			},
			inactive_tab_hover = {
				bg_color = '#BABBF1',
				fg_color = '#626880',
			},
			new_tab = {
				bg_color = '#BABFF1',
				fg_color = '#626880',
			},
			new_tab_hover = {
				bg_color = '#F4B8E4',
				fg_color = '#FFFFFF',
			},
		},
	},
	window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	},
}
