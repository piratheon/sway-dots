<img width="1366" height="768" alt="screenshot-2026-01-10-15:22:27" src="https://github.com/user-attachments/assets/deb14547-3c5a-4353-b30c-b7e66228ed89" />

# My Sway & Nushell Dotfiles

This repository contains a backup of my personal dotfiles for Sway, Nushell, and related terminal/shell applications. It also includes an installer script to help set up a new system with these configurations.

## Included Dotfiles

This backup contains configurations for the following applications:

- **Sway:** The main Wayland compositor configuration.
- **Nushell:** The shell environment and configuration.
- **Waybar:** The status bar.
- **Rofi & Wofi:** Application launchers and menus.
- **Kitty & Alacritty:** Terminal emulators.
- **Mako:** Notification daemon.
- **Foot:** Another terminal emulator.
- **WPGTK (`wpg`):** Wallpaper and theming manager.
- **nwg-shell components:** Includes `nwg-bar`, `nwg-grid`, `nwg-panel`, and `nwg-wrapper`.
- **Wlogout:** Logout menu.
- **EWW:** Elkowars Wacky Widgets, for custom widgets.
- **Fastfetch:** A tool for fetching system information.

## Dependencies

The `install.sh` script attempts to install the following dependencies. Please review and adjust the list for your specific system. The primary package manager is assumed to be `paru` (for Arch Linux with AUR support), but can be changed in the script.

### Software Packages

`alacritty`, `audio-recorder`, `autotiling`, `avizo`, `bat`, `blueman`, `btop`, `brightnessctl` (or `light`), `brave-browser`, `colorthief`, `conky`, `curl`, `discord`, `docker`, `dunst`, `eww`, `eza`, `expac`, `fastfetch`, `ffmpeg`, `firefox` (or `firedragon`), `flatpak`, `foot`, `gnome-text-editor`, `glow`, `grim`, `grimshot`, `hwinfo`, `imagemagick`, `jetbrains-idea`, `jq`, `kvantum`, `libinput-gestures`, `libnotify`, `lxappearance`, `mako`, `networkmanager`, `networkmanager-applet`, `networkmanager-dmenu`, `netcat`, `npm-check-updates` (npm package), `neovim`, `nwg-bar`, `nwg-grid`, `nwg-launchers`, `nwg-panel`, `nwg-wrapper`, `nwgdmenu`, `ori`, `pamac`, `pavucontrol`, `pcmanfm`, `playerctl`, `polkit-gnome`, `polybar`, `poweralertd`, `procps-ng`, `python`, `qt5ct`, `ranger`, `reflector`, `ripgrep`, `rofi`, `slurp`, `spotify`, `steam`, `sway`, `swayidle`, `swaylock`, `swww`, `telegram-desktop`, `tracker`, `translate-shell`, `urxvt`, `vimcat`, `volumectl`, `waybar`, `waybar-mpris`, `wget`, `wlogout`, `wofi`, `wpg`, `xsettingsd`, `xdg-user-dirs`, `xdg-utils`, `xsane`, `yad`.

### Fonts

- `ttf-jetbrains-mono-nerd`
- `ttf-meslo-lgs-nerd`
- `noto-fonts`
- `ttf-hack-fonts`

## Installation

1.  **Clone this repository** or copy the `sway-dots` folder to your home directory.
2.  **Review the `install.sh` script.** Make sure the package manager and dependency lists are appropriate for your system.
3.  **Run the installer:**
    ```bash
    cd ~/sway-dots
    ./install.sh
    ```
4.  **Follow the prompts.** The script will ask for confirmation before installing dependencies and deploying dotfiles.
5.  **Reboot or log out.** This is recommended for all changes to take effect.

### Manual Installation

If you prefer not to use the script:

1.  **Manually install the dependencies** listed above using your system's package manager.
2.  **Copy the configuration folders** from `~/sway-dots/` to your `~/.config/` directory. For example:
    ```bash
    cp -r ~/sway-dots/sway ~/.config/
    cp -r ~/sway-dots/nushell ~/.config/
    # etc.
    ```

**Note:** The installer script uses `rsync` to copy all contents of the `sway-dots` directory (excluding the script and README) to `~/.config/`. This is a broad approach and may need to be tailored if some configurations are expected to be in different locations (e.g., directly in `~/`).
