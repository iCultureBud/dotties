#! /usr/bin/bash

# Environment
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY \
        WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

# GTK Theming
gsettings set org.gnome.desktop.interface gtk-theme Gruvbox-Dark-Medium
gsettings set org.gnome.desktop.wm.preferences theme Gruvbox-Dark-Medium
gsettings set org.gnome.desktop.interface icon-theme Gruvbox-Plus-Dark
gsettings set org.gnome.desktop.interface cursor-theme Bibata-Modern-Ice

wlsunset -l 46.9 -L 15.2 -t 5800 &
wl-paste -t text --watch clipman store &
swaybg -i ~/Pictures/wallpapers/cozy_place.jpg &

exit 0
