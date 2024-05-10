import os


def on_startup():
    os.system('systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
    os.system('hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
        WAYLAND_DISPLAY XDG_CURRENT_DESKTOP')
    os.system('wlsunset -l 46.9 -L 15.2 -t 3500 &')
    os.system('wl-paste -t text --watch clipman store &')
    #  os.system("remind -z -k'notify-send \"Reminder:\" \"%s\"' ~/.reminders.rem &")


def on_reconfigure():
    os.system('notify-send newm "Reloaded config" &')


def configure_gtk():
    gnome_schema = 'org.gnome.desktop.interface'
    wm_service_extra_config = (
        f"gsettings set {gnome_schema} gtk-theme Nordic-Polar",  # change to the theme of your choice
        #  f"gsettings set {gnome_schema} icon-theme Tela",  # change to the icon of your choice
        f"gsettings set {gnome_schema} cursor-theme BreezeX",  # change to the cursor of your choice
    )

    for config in wm_service_extra_config:
        config = f"{config} &"
        os.system(config)


########
# View #
########
corner_radius = 10

outputs = [
    #  {'name': 'HDMI-A-1', 'pos_x': 0, 'pos_y': 0, 'scale': 1.25},
    {'name': 'DP-1', 'pos_x': 0, 'pos_y': 0, 'scale': 1},
    {'name': 'eDP-1', 'pos_x': 2560, 'pos_y': 0, 'scale': 1},
]

pywm = {
    'xkb_layout': "us",
    'xcursor_theme': 'BreezeX',
    'xcursor_size': 24,
    'xkb_options': 'caps:super',

    'natural_scroll': False,
    'texture_shaders': 'basic',
    'renderer_mode': 'pywm',

    'enable_xwayland': True,
    'encourage_csd': False
}

focus = {
    'color': '#8CAAEE',
    'distance': 2.2,
    'animate_on_change': True,
    'anim_time': 0.2,
    'enabled': True
}

swipe_zoom = {
    "grid_m": 1,
    "grid_ovr": 0.02,
}


def rules(view):
    want_blur = ['wezterm', 'wofi']

    if view.app_id == 'kitty-float':
        return {'float': True, 'float_size': (1000, 500), 'float_pos': (0.5, 0.5)}

    if view.app_id in want_blur:
        return {'blur': {'radius': 4, 'passes': 6}}

    if view.app_id == 'pavucontrol':
        return {'float': True, 'float_size': (600, 600), 'float_pos': (0.5, 0.5)}

    if view.title is not None and view.title.strip() == 'Firefox — Sharing Indicator':
        return {'float': True, 'float_size': (100, 40), 'float_pos': (0.5, 0.1)}

    if view.title is not None and view.title.strip() == 'File Upload':
        return {'float': True, 'float_size': (1000, 800), 'float_pos': (0.5, 0.5)}

    if view.title is not None and view.title.strip() == 'Add activity':
        return {'float': True, 'float_size': (600, 400), 'float_pos': (0.5, 0.5)}

    return None


view = {
    'padding': 16,
    'fullscreen_padding': 0,
    'send_fullscreen': False,
    'accept_fullscreen': True,

    'rules': rules,
    'floating_min_size': False,

    'debug_scaling': False,
    'border_ws_switch': 100,
}

swipe_zoom = {
    'grid_m': 1,
    'grid_ovr': 0.02,
}

mod = 'L'

background = {
    'path': os.environ['HOME'] + '/Pictures/wallpapers/breach.png',
    'time_scale': 0.15,
    'anim': False,
}

anim_time = .2
blend_time = .5


###############
# Keybindings #
###############
key_bindings = lambda layout: [

    # General movement #
    (mod+"-h", lambda: layout.move(-1, 0)),
    (mod+"-j", lambda: layout.move(0, 1)),
    (mod+"-k", lambda: layout.move(0, -1)),
    (mod+"-l", lambda: layout.move(1, 0)),
    (mod+"-t", lambda: layout.move_in_stack(1)),
    (mod+"-u", lambda: layout.basic_scale(1)),
    (mod+"-n", lambda: layout.basic_scale(-1)),

    (mod+"-H", lambda: layout.move_focused_view(-1, 0)),
    (mod+"-J", lambda: layout.move_focused_view(0, 1)),
    (mod+"-K", lambda: layout.move_focused_view(0, -1)),
    (mod+"-L", lambda: layout.move_focused_view(1, 0)),

    (mod+"-C-h", lambda: layout.resize_focused_view(-1, 0)),
    (mod+"-C-j", lambda: layout.resize_focused_view(0, 1)),
    (mod+"-C-k", lambda: layout.resize_focused_view(0, -1)),
    (mod+"-C-l", lambda: layout.resize_focused_view(1, 0)),

    (mod+"-v", lambda: layout.toggle_focused_view_floating()),
    (mod+"-W", lambda: layout.change_focused_view_workspace()),
    (mod+"-w", lambda: layout.move_workspace()),
    (mod+"-s", lambda: os.system("grim -g \"$(slurp)\" ~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%m-%s).png &")),
    (mod+"-q", lambda: layout.close_view()),
    (mod+"-c", lambda: os.system("clipman pick -t wofi &")),

    (mod+"-i", lambda: layout.toggle_fullscreen()),

    # Application shortcuts #
    (mod+"-Return", lambda: os.system("wezterm &")),
    (mod+"-C-Return", lambda: os.system("wezterm --class kitty-float &")),
    (mod+"-f", lambda: os.system("librewolf &")),
    (mod+"-m", lambda: os.system("spotify &")),
    (mod+"-e", lambda: os.system("thunar &")),
    (mod+"-y", lambda: os.system("freetube &")),

    # WM shortcuts #
    (mod+"-p", lambda: layout.ensure_locked(dim=True)),
    (mod+"-P", lambda: layout.terminate()),
    (mod+"-R", lambda: layout.update_config()),

    (mod+"-z", lambda: layout.swallow_focused_view()),
    (mod+"-", lambda: layout.toggle_overview(only_active_workspace=False)),

    # Launchers #
    (mod+"-o", lambda: layout.enter_launcher_overlay()),
    (mod+"-r", lambda: os.system("wofi --show drun -W 30% &")),

    # Media Keys #
    ("XF86AudioPrev", lambda: os.system("playerctl previous")),
    ("XF86AudioNext", lambda: os.system("playerctl next")),
    ("XF86AudioPlay", lambda: os.system("playerctl play-pause")),

    ("XF86AudioRaiseVolume", lambda: os.system("pactl set-sink-volume 0 +2%")),
    ("XF86AudioLowerVolume", lambda: os.system("pactl set-sink-volume 0 -2%")),
    ("XF86AudioMute", lambda: os.system("pactl set-sink-mute 0 toggle")),

]


###############
# Other stuff #
###############
swipe = {
    'gesture_factor': 3
}

gestures = {
    'lp_freq': 120.0,
    'lp_inertia': 0.4,
}

panels = {
    'lock': {
        'cmd': 'wezterm newm-panel-basic lock',
        'w': 0.7,
        'h': 0.6,
        'corner_radius': 50,
    },
    'launcher': {
        'cmd': 'wezterm newm-panel-basic launcher',
        'w': 0.7,
        'h': 0.6,
        'corner_radius': 50,
    },
    'bar': {
        'cmd': 'waybar',
    },
}

grid = {
    'throw_ps': [2, 10]
}

energy = {
    'idle_times': [6000, 10000]
}
