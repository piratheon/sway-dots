<img width="1366" height="768" alt="screenshot-2026-01-10-15:22:27" src="https://github.com/user-attachments/assets/deb14547-3c5a-4353-b30c-b7e66228ed89" />

# My Sway & Nushell Dotfiles

This repository contains a backup of my personal dotfiles for Sway, Nushell, and related terminal/shell applications. It also includes an installer script to help set up a new system with these configurations.

## Features

- **Multi-Distribution Support**: Automatically detects your distribution (Arch, Debian, Fedora, and others) and installs appropriate packages
- **Customizable UI Effects**: Toggle UI blur effects during installation
- **Keyboard Layout Selection**: Choose your preferred keyboard layouts during installation
- **Comprehensive Configuration**: Includes configurations for all major Wayland components

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

## Installation

1.  **Clone this repository** or copy the `sway-dots` folder to your home directory.
2.  **Review the `install.sh` script.** Make sure the package manager and dependency lists are appropriate for your system.
3.  **Make the installer executable:**
    ```bash
    chmod +x install.sh
    ```
4.  **Run the installer:**
    ```bash
    ./install.sh
    ```
5.  **Follow the prompts.** The script will:
    - Detect your distribution
    - Ask if you want to enable UI blur effects
    - Ask if you want to customize keyboard layouts
    - Install dependencies appropriate for your distribution
    - Deploy the configuration files
6.  **Reboot or log out.** This is recommended for all changes to take effect.

### Manual Installation

If you prefer not to use the script:

1.  **Manually install the dependencies** listed in the appropriate `distro-configs/[distro]/packages.txt` file using your system's package manager.
2.  **Copy the configuration folders** from `~/sway-dots/` to your `~/.config/` directory. For example:
    ```bash
    cp -r ~/sway-dots/sway ~/.config/
    cp -r ~/sway-dots/nushell ~/.config/
    # etc.
    ```

## Supported Distributions

- **Arch Linux** (and derivatives like Manjaro, Garuda) - Uses `paru`/`yay`/`pacman`
- **Debian/Ubuntu** (and derivatives) - Uses `apt`
- **Fedora** - Uses `dnf`
- **openSUSE** - Uses `zypper` (experimental)

## Customization Options

During installation, the script will prompt you for:

1. **UI Blur Effects**: Enable or disable blur effects in Sway
2. **Keyboard Layouts**: Choose your preferred keyboard layouts (defaults to French if not customized)

## Dependencies

The `install.sh` script attempts to install the following dependencies based on your detected distribution. Please review the appropriate `distro-configs/[distro]/packages.txt` file for your specific system.

### Software Packages

The installer will install different packages depending on your distribution:
- **Arch**: `alacritty`, `audio-recorder`, `autotiling`, `avizo`, `bat`, `blueman`, `btop`, `brightnessctl`, `colorthief`, `conky`, `curl`, `dunst`, `eww`, `eza`, `expac`, `fastfetch`, `ffmpeg`, `flatpak`, `foot`, `gnome-text-editor`, `glow`, `grim`, `grimshot`, `hwinfo`, `imagemagick`, `jq`, `kvantum`, `libinput-gestures`, `libnotify`, `lxappearance`, `mako`, `networkmanager`, `networkmanager-applet`, `networkmanager-dmenu`, `netcat`, `neovim`, `ori`, `pamac`, `pavucontrol`, `pcmanfm`, `playerctl`, `polkit-gnome`, `poweralertd`, `procps-ng`, `python`, `qt5ct`, `ranger`, `reflector`, `ripgrep`, `rofi`, `slurp`, `swayfx`, `swayidle`, `swaylock`, `swww`, `tracker`, `translate-shell`, `urxvt`, `vimcat`, `volumectl`, `waybar`, `waybar-mpris`, `wget`, `wlogout`, `wofi`, `wpg`, `xsettingsd`, `xdg-user-dirs`, `xdg-utils`, `xsane`, `yad`.

- **Debian/Ubuntu**: Similar packages adapted for the Debian ecosystem
- **Fedora**: Similar packages adapted for the Fedora ecosystem

### Fonts

Font packages are also installed based on your distribution:
- **Arch**: `ttf-jetbrains-mono-nerd`, `ttf-meslo-lgs-nerd`, `noto-fonts`, `ttf-hack-fonts`
- **Debian/Ubuntu**: `fonts-noto-color-emoji`, `fonts-jetbrains-mono`, `fonts-liberation`, etc.
- **Fedora**: `jetbrains-mono-fonts`, `liberation-fonts`, `dejavu-sans-fonts`, etc.

**Note:** The installer script uses `rsync` to copy all contents of the `sway-dots` directory (excluding the script and README) to `~/.config/`. This is a broad approach and may need to be tailored if some configurations are expected to be in different locations (e.g., directly in `~/`).
