<img width="1366" height="768" alt="screenshot-2026-01-10-15:22:27" src="https://github.com/user-attachments/assets/deb14547-3c5a-4353-b30c-b7e66228ed89" />

# My Sway & Nushell Dotfiles

This repository contains a backup of my personal dotfiles for Sway, Nushell, and related terminal/shell applications. It also includes an installer script to help set up a new system with these configurations, with support for multiple Linux distributions.

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

## Features

- **Multi-Distribution Support**: The install script automatically detects your Linux distribution and installs appropriate packages
- **Distro-Specific Configurations**: Different configurations for Arch, Debian/Ubuntu, Fedora, and openSUSE
- **Automatic Dependency Resolution**: Installs all required packages and fonts
- **Backup & Restore**: Backs up existing configurations before installing new ones

## Supported Distributions

- **Arch Linux** and derivatives (Manjaro, EndeavourOS)
- **Debian** and derivatives (Ubuntu, Linux Mint, Kali)
- **Fedora** and derivatives (RHEL, CentOS, Rocky Linux, AlmaLinux)
- **openSUSE** (Leap and Tumbleweed)

## Dependencies

The `install.sh` script automatically detects your distribution and installs the following dependencies:

### Software Packages

**Arch Linux:**
`alacritty`, `audio-recorder`, `autotiling`, `avizo`, `bat`, `blueman`, `btop`, `brightnessctl`, `curl`, `dunst`, `eww`, `eza`, `expac`, `fastfetch`, `ffmpeg`, `flatpak`, `foot`, `gedit`, `glow`, `grim`, `grimshot`, `hwinfo`, `imagemagick`, `jq`, `kvantum`, `libinput-gestures`, `libnotify`, `lxappearance`, `mako`, `networkmanager`, `networkmanager-applet`, `networkmanager-dmenu`, `netcat`, `neovim`, `pamac`, `pavucontrol`, `pcmanfm`, `playerctl`, `polkit-gnome`, `poweralertd`, `procps-ng`, `python`, `qt5ct`, `ranger`, `reflector`, `ripgrep`, `rofi`, `slurp`, `swayfx`, `swayidle`, `swaylock`, `swww`, `tracker`, `translate-shell`, `urxvt`, `vimcat`, `waybar`, `wget`, `wlogout`, `wofi`, `wpg`, `xsettingsd`, `xdg-user-dirs`, `xdg-utils`, `xsane`, `yad`.

**Debian/Ubuntu:**
`alacritty`, `audio-recorder`, `bat`, `blueman`, `btop`, `brightnessctl`, `curl`, `dunst`, `eza`, `fastfetch`, `ffmpeg`, `flatpak`, `foot`, `gedit`, `glow`, `grim`, `grimshot`, `hwinfo`, `imagemagick`, `jq`, `libinput-tools`, `libnotify`, `lxappearance`, `mako`, `network-manager`, `network-manager-gnome`, `network-manager-dmenu`, `netcat`, `neovim`, `pavucontrol`, `pcmanfm`, `playerctl`, `policykit-1-gnome`, `powertop`, `procps`, `python3`, `qt5ct`, `ranger`, `ripgrep`, `rofi`, `slurp`, `sway`, `swayidle`, `swaylock`, `swww`, `tracker3`, `translate-shell`, `rxvt-unicode`, `vim-common`, `waybar`, `wget`, `wlogout`, `wofi`, `xsettingsd`, `xdg-user-dirs`, `xdg-utils`, `xsane`, `yad`.

**Fedora:**
`alacritty`, `audio-recorder`, `bat`, `blueman`, `btop`, `brightnessctl`, `curl`, `dunst`, `eza`, `fastfetch`, `ffmpeg`, `flatpak`, `foot`, `gedit`, `glow`, `grim`, `grimshot`, `hwinfo`, `ImageMagick`, `jq`, `libinput`, `libnotify`, `lxappearance`, `mako`, `NetworkManager`, `NetworkManager-tui`, `NetworkManager-libnm`, `pavucontrol`, `pcmanfm`, `playerctl`, `polkit-gnome`, `powertop`, `procps-ng`, `python3`, `qt5ct`, `ranger`, `ripgrep`, `rofi`, `slurp`, `sway`, `swayidle`, `swaylock`, `swww`, `tracker`, `translate-shell`, `rxvt`, `vim-common`, `waybar`, `wget`, `wlogout`, `wofi`, `xsettingsd`, `xdg-user-dirs`, `xdg-utils`, `xsane`, `yad`.

### Fonts

Font packages vary by distribution but include similar equivalents of:
- JetBrains Mono Nerd Font
- Meslo LGS Nerd Font
- Noto Fonts
- Hack Fonts

## Installation

1.  **Clone this repository** or copy the `sway-dots` folder to your home directory.
2.  **Review the `install.sh` script.** The script will automatically detect your distribution.
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

**Note:** The installer script uses `rsync` to copy all contents of the `sway-dots` directory (excluding the script and README) to `~/.config/`. The script also supports distro-specific overrides in the `distro-configs/` directory.
