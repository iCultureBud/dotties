local wezterm = require('wezterm')
local act = wezterm.action

local function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'Gruvbox Material (Gogh)'
	else
		return 'GruvboxLight'
	end
end

wezterm.on('window-config-reloaded', function(window)
	local overrides = window:get_config_overrides() or {}
	local appearance = window:get_appearance()
	local scheme = scheme_for_appearance(appearance)
	if overrides.color_scheme ~= scheme then
		overrides.color_scheme = scheme
		window:set_config_overrides(overrides)
	end
end)

return {
	-- window_decorations = "RESIZE",
	enable_wayland = true,
	check_for_updates = false,
	window_close_confirmation = 'NeverPrompt',
	hide_tab_bar_if_only_one_tab = true,
	font_size = 19,
	window_background_opacity = .90,
	macos_window_background_blur = 80,
	native_macos_fullscreen_mode = false,
	font = wezterm.font_with_fallback {
		'JetBrainsMono Nerd Font Mono',
		'FiraCode Nerd Font Mono',
	},
	window_frame = {
		font = wezterm.font('JetBrainsMono Nerd Font Mono'),
		-- active_titlebar_bg = '#282828',
		inactive_titlebar_bg = '#232634',
	},
	keys = {
		{ key = 'K', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-2) },
		{ key = 'J', mods = 'CTRL|SHIFT', action = act.ScrollByLine(2) },
		{ key = 'F', mods = 'CMD|SHIFT', action = wezterm.action.ToggleFullScreen },
		{ key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = false },
  },
	},
	colors = {
		tab_bar = {
			-- background = '#282828',
			active_tab = {
				bg_color = '#3C3836',
				fg_color = '#DDC7A1',
			},
			inactive_tab = {
				bg_color = '#282828',
				fg_color = '#504945',
			},
			inactive_tab_hover = {
				bg_color = '#D4BE98',
				fg_color = '#3C3836',
			},
			new_tab = {
				bg_color = '#D4BE98',
				fg_color = '#3C3836',
			},
			new_tab_hover = {
				bg_color = '#D4BE98',
				fg_color = '#3C3836',
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
