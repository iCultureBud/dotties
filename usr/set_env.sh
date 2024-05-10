#!/bin/sh

#
# GTK environment
#
export TDESKTOP_DISABLE_GTK_INTEGRATION=1
export CLUTTER_BACKEND=wayland
export BEMENU_BACKEND=wayland
export GDK_BACKEND=wayland

#
# Firefox
#
export MOZ_ENABLE_WAYLAND=1

#
# Qt environment
#
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_FORCE_DPI=physical
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
