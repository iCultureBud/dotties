#! /bin/sh

# Lock screen, when idle
swayidle -w \
    timeout 300 '~/.config/sway/scripts/lock.sh -f --grace 12 --fade-in 10' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"; sleep 2; swaymsg "output * enable"' \
	before-sleep 'pgrep swaylock || ~/.config/sway/scripts/lock.sh -f --fade-in 0 && true'
