#!/bin/bash

# This script installs dotfiles and their dependencies.
# Please review the script before running it.

# --- Configuration ---
# Set your preferred package manager. Examples: paru, yay, apt, dnf, pacman, etc.
# If using a non-AUR helper (like pacman), you may need to manually install AUR packages.
PKG_MANAGER="paru" 

# --- Dependencies ---
# These are the software packages identified from your dotfiles.
# This list is based on executables and applications found in your configs.
# Review and adjust as needed for your specific system and preferences.
SOFTWARE_PACKAGES=(
    "alacritty"
    "audio-recorder"
    "autotiling"
    "avizo" # For avizo-service and avizo-client
    "bat"
    "blueman" # For blueman-manager
    "btop"
    "brightnessctl" # Alternative: "light"
    "colorthief" # Python package or CLI tool
    "curl"
    "dunst"
    "eww"
    "eza"
    "expac"
    "fastfetch"
    "ffmpeg"
    "flatpak"
    "foot"
    "gedit"
    "glow"
    "grim"
    "grimshot" # Often part of sway or a separate package
    "hwinfo"
    "imagemagick" # For 'convert' and 'magick'
    "jq"
    "kvantum" # For kvantummanager
    "libinput-gestures"
    "libnotify" # For 'notify-send'
    "lxappearance"
    "mako"
    "networkmanager" # For nmtui
    "networkmanager-applet" # For nm-applet
    "networkmanager-dmenu"
    "netcat" # For 'nc'
    "neovim" # For 'nvim'
    "ori"
    "pamac" # For pamac-manager
    "pavucontrol"
    "pcmanfm"
    "playerctl"
    "polkit-gnome" # For polkit-gnome-authentication-agent
    "poweralertd"
    "procps-ng" # For 'pstree', 'pwdx'
    "python" # For python scripts
    "qt5ct"
    "ranger"
    "reflector"
    "ripgrep" # For 'rg'
    "rofi"
    "slurp"
    "swayfx"
    "swayidle"
    "swaylock"
    "swww" # For swww-daemon and swww
    "tracker" # For 'tracker daemon', likely tracker3
    "translate-shell"
    "urxvt" # If you intend to use it, otherwise remove
    "vimcat"
    "volumectl" # Custom utility, ensure it's available in your PATH or change this.
    "waybar"
    "waybar-mpris"
    "wget"
    "wlogout"
    "wofi"
    "wpg"
    "xsettingsd"
    "xdg-user-dirs"
    "xdg-utils" # For 'xdg-open'
    "xsane"
    "yad"
)

# These are the font packages identified from your dotfiles.
FONT_PACKAGES=(
    "ttf-jetbrains-mono-nerd"
    "ttf-meslo-lgs-nerd" # Or ttf-caskaydia-cove-nerd
    "noto-fonts"
    "ttf-hack-fonts"
    # Add other icon fonts like font-awesome if needed based on your setup.
)

# --- Functions ---
install_dependencies() {
    echo "Attempting to install software dependencies..."
    if [[ "$PKG_MANAGER" == "paru" || "$PKG_MANAGER" == "yay" ]]; then
        sudo "$PKG_MANAGER" -Syu --needed --noconfirm "${SOFTWARE_PACKAGES[@]}" "${FONT_PACKAGES[@]}"
    elif [[ "$PKG_MANAGER" == "pacman" ]]; then
        sudo "$PKG_MANAGER" -Syu --needed --noconfirm "${SOFTWARE_PACKAGES[@]}" "${FONT_PACKAGES[@]}"
        echo "WARNING: Some packages might be from AUR. Please install them manually using an AUR helper like paru/yay or from source."
    elif command -v "$PKG_MANAGER" &> /dev/null; then
        echo "Using '$PKG_MANAGER' for installation. Please ensure it supports all packages."
        sudo "$PKG_MANAGER" install -y "${SOFTWARE_PACKAGES[@]}" "${FONT_PACKAGES[@]}"
    else
        echo "Error: Package manager '$PKG_MANAGER' not found. Please install dependencies manually."
        return 1
    fi

    # Handle npm-check-updates separately as it's an npm package
    if ! command -v ncu &> /dev/null; then
        echo "Installing npm-check-updates (ncu)..."
        npm install -g npm-check-updates
    fi

    # Handle python pip packages separately, e.g., colorthief if it's a pip package
    if ! command -v colorthief &> /dev/null && pip show colorthief &> /dev/null; then
        echo "Installing colorthief via pip..."
        pip install colorthief
    fi

    echo "Dependencies installation attempted. Please check for errors."
}

deploy_dotfiles() {
    echo "Deploying dotfiles to ~/.config/..."
    local SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

    # Ensure ~/.config exists
    mkdir -p "$HOME/.config"

    # Copy config directories
    rsync -avh --exclude 'install.sh' --exclude 'README.md' "$SCRIPT_DIR/" "$HOME/.config/"
    
    # Move nushell config to the correct location in ~/.config
    if [ -d "$HOME/.config/nushell" ]; then
        mv "$HOME/.config/nushell" "$HOME/.config/nushell_backup_$(date +%Y%m%d_%H%M%S)" || true
    fi
    cp -r "$SCRIPT_DIR/nushell" "$HOME/.config/"

    # Restore some configs to home directory if they were copied from there
    # E.g., if .gtkrc-2.0 or .bashrc was intended to be in ~
    # For now, assuming all go into ~/.config/<app_name>
    echo "Dotfiles deployment complete. You may need to manually move some files if they belong directly in ~/"
    echo "For example, some shell configs like .bashrc, .zshrc etc., should be in your home directory, not ~/.config"
}

# --- Main execution ---
echo "This script will help you set up your Sway/Nushell dotfiles."
echo "Dependencies will be installed and configuration files will be deployed."

read -p "Do you want to install dependencies? (y/N): " install_choice
if [[ "$install_choice" =~ ^[Yy]$ ]]; then
    install_dependencies
    if [ $? -ne 0 ]; then
        echo "Dependency installation failed. Exiting."
        exit 1
    fi
fi

read -p "Do you want to deploy dotfiles? (y/N): " deploy_choice
if [[ "$deploy_choice" =~ ^[Yy]$ ]]; then
    deploy_dotfiles
fi

echo "Setup script finished. Please reboot or log out for changes to take effect."
echo "Remember to source your shell configuration files (e.g., .bashrc, .zshrc, config.nu) if they were just moved."
