#! /bin/sh

# Lock screen, when idle
swayidle -w \
    timeout 600 '~/.config/hypr/scripts/lock.sh -f' \
	before-sleep 'pgrep swaylock || ~/.config/hypr/scripts/lock.sh -f && true'
