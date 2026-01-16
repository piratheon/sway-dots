#!/bin/bash

# GTK Theming
~/.config/sway/scripts/import-gsettings

# Sway configs
gtk_theme="Everforest-Dark"
icon_theme="Papirus-Dark"
cursor_theme="xcursor-breeze"
gui_font="JetBrainsMono Medium 11"
term_font="JetBrainsMono Nerd Font 14"
gtk_color_scheme="prefer-dark"
kvantum_theme="Matcha-Dark"

gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme"
gsettings set org.gnome.desktop.interface icon-theme "$icon_theme"
gsettings set org.gnome.desktop.interface cursor-theme "$cursor_theme"
gsettings set org.gnome.desktop.interface font-name "$gui_font"
gsettings set org.gnome.desktop.interface color-scheme "$gtk_color_scheme"
gsettings set org.gnome.desktop.input-sources show-all-sources true
gsettings set org.gnome.desktop.interface monospace-font-name "$term_font"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
kvantummanager --set "$kvantum_theme"

# Autostart applications
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
mako -c ~/.config/mako/everforest &
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK &
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK &
swayidle -w timeout 500 'swaymsg "output * dpms off"' resume 'swaymsg "output * dpms on"' timeout 700 'systemctl suspend' &
avizo-service &
avizo-client --time=1 &
avizo-client --background="rgba(73, 78, 81, 0.8)" &
tracker daemon -s &
~/.config/sway/scripts/light.sh 1 &
poweralertd -s -i "line power" &
playerctl -a metadata --format '{{status}} {{title}}' --follow | while read line; do pkill -RTMIN+5 waybar; done &
pcmanfm -d &
xdg-user-dirs-update &
nm-applet --indicator &
autotiling &
waybar &
swww-daemon -f xrgb &
swww img $HOME/Pictures/wallpapers/nasa.jpg &
