#! /usr/bin/bash

# Environment
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
        WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# GTK Theming
gsettings set org.gnome.desktop.interface gtk-theme Nordic-Polar
gsettings set org.gnome.desktop.wm.preferences theme Nordic
gsettings set org.gnome.desktop.interface icon-theme Zafiro-Nord-Black-Blue
gsettings set org.gnome.desktop.interface cursor-theme BreezeX

# Autostart for Hyprland
hyprctl setcursor BreezeX 24 &
hyprpaper &
waybar &
mako &
wlsunset -l 46.9 -L 15.2 -t 3500 &
wl-paste -t text --watch clipman store & remind -z -k'notify-send \"Reminder:\" \"%s\"' ~/.reminders.rem &
# remind -z -k'notify-send \"Reminder:\" \"%s\"' ~/.reminders.rem &
swayidle -w \
    timeout 600 '~/.config/hypr/scripts/lock.sh -f' \
	before-sleep 'pgrep swaylock || ~/.config/hypr/scripts/lock.sh -f && true'

exit 0
