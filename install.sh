#!/bin/bash

# This script installs dotfiles and their dependencies with distribution-specific support.
# Please review the script before running it.

# --- Distribution Detection ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$NAME
        DISTRO_ID=$ID
        PKG_MANAGER=""
        
        case $DISTRO_ID in
            arch|manjaro|endeavouros)
                PKG_MANAGER="pacman"
                AUR_HELPER="paru"  # Can be overridden by user
                ;;
            ubuntu|debian|mint|kali)
                PKG_MANAGER="apt"
                ;;
            fedora|rhel|centos|rocky|almalinux)
                PKG_MANAGER="dnf"
                ;;
            opensuse-leap|opensuse-tumbleweed)
                PKG_MANAGER="zypper"
                ;;
            *)
                echo "Unsupported distribution: $DISTRO ($DISTRO_ID)"
                echo "Defaulting to Arch-based package manager."
                PKG_MANAGER="pacman"
                ;;
        esac
        
        echo "Detected distribution: $DISTRO ($DISTRO_ID)"
        echo "Package manager: $PKG_MANAGER"
    else
        echo "Cannot detect distribution. /etc/os-release not found."
        exit 1
    fi
}

# --- Configuration ---
# Auto-detected package manager, but can be overridden by user
detect_distro

# Allow user to override package manager if needed
read -p "Use detected package manager ($PKG_MANAGER)? Press Enter to continue, or enter alternative: " USER_PKG_MANAGER
if [ -n "$USER_PKG_MANAGER" ]; then
    PKG_MANAGER="$USER_PKG_MANAGER"
fi

# --- Distribution-Specific Dependencies ---
# Define packages for each distribution
declare -A ARCH_PACKAGES=(
    ["software"]="alacritty audio-recorder autotiling avizo bat blueman btop brightnessctl curl dunst eww eza expac fastfetch ffmpeg flatpak foot gedit glow grim grimshot hwinfo imagemagick jq kvantum libinput-gestures libnotify lxappearance mako networkmanager networkmanager-applet networkmanager-dmenu netcat neovim pamac pavucontrol pcmanfm playerctl polkit-gnome poweralertd procps-ng python qt5ct ranger reflector ripgrep rofi slurp swayfx swayidle swaylock swww tracker translate-shell urxvt vimcat waybar wget wlogout wofi wpg xsettingsd xdg-user-dirs xdg-utils xsane yad"
    ["fonts"]="ttf-jetbrains-mono-nerd ttf-meslo-lgs-nerd noto-fonts ttf-hack-fonts"
)

declare -A DEBIAN_PACKAGES=(
    ["software"]="alacritty audio-recorder bat blueman btop brightnessctl curl dunst eza fastfetch ffmpeg flatpak foot gedit glow grim grimshot hwinfo imagemagick jq libinput-tools libnotify lxappearance mako network-manager network-manager-gnome network-manager-dmenu netcat neovim pavucontrol pcmanfm playerctl policykit-1-gnome powertop procps python3 qt5ct ranger ripgrep rofi slurp sway swayidle swaylock swww tracker3 translate-shell rxvt-unicode vim-common waybar wget wlogout wofi xsettingsd xdg-user-dirs xdg-utils xsane yad"
    ["fonts"]="fonts-noto-color-emoji fonts-hack-ttf fonts-liberation fonts-dejavu-core fonts-font-awesome"
)

declare -A FEDORA_PACKAGES=(
    ["software"]="alacritty audio-recorder bat blueman btop brightnessctl curl dunst eza fastfetch ffmpeg flatpak foot gedit glow grim grimshot hwinfo ImageMagick jq libinput libnotify lxappearance mako NetworkManager NetworkManager-tui NetworkManager-libnm pavucontrol pcmanfm playerctl polkit-gnome powertop procps-ng python3 qt5ct ranger ripgrep rofi slurp sway swayidle swaylock swww tracker translate-shell rxvt vim-common waybar wget wlogout wofi xsettingsd xdg-user-dirs xdg-utils xsane yad"
    ["fonts"]="google-noto-emoji-fonts hack-fonts liberation-fonts dejavu-sans-fonts fontawesome-fonts"
)

declare -A OPEN_SUSE_PACKAGES=(
    ["software"]="alacritty audio-recorder bat blueman btop brightnessctl curl dunst eza fastfetch ffmpeg flatpak foot gedit glow grim grimshot hwinfo ImageMagick jq libinput libnotify lxappearance mako NetworkManager NetworkManager-applet NetworkManager-cli pavucontrol pcmanfm playerctl polkit-gnome powertop procps python3 qt5ct ranger ripgrep rofi slurp sway swayidle swaylock swww tracker translate-shell rxvt vim-common waybar wget wlogout wofi xsettingsd xdg-user-dirs xdg-utils xsane yad"
    ["fonts"]="google-noto-emoji-fonts hack-fonts liberation-fonts dejavu-sans-fonts google-noto-sans-fonts"
)

# --- Functions ---
install_dependencies() {
    echo "Attempting to install software dependencies for $DISTRO_ID..."
    
    case $DISTRO_ID in
        arch|manjaro|endeavouros)
            # Check if AUR helper is available, if not install paru
            if command -v paru &> /dev/null; then
                AUR_HELPER="paru"
            elif command -v yay &> /dev/null; then
                AUR_HELPER="yay"
            else
                echo "No AUR helper found. Installing paru..."
                sudo pacman -S --needed --noconfirm base-devel git
                git clone https://aur.archlinux.org/paru.git /tmp/paru
                cd /tmp/paru
                makepkg -si --noconfirm
                cd -
                AUR_HELPER="paru"
            fi
            
            echo "Installing packages using $AUR_HELPER..."
            sudo $AUR_HELPER -Syu --needed --noconfirm ${ARCH_PACKAGES[software]} ${ARCH_PACKAGES[fonts]}
            ;;
            
        ubuntu|debian|mint|kali)
            # Update package list
            sudo apt update
            sudo apt install -y ${DEBIAN_PACKAGES[software]} ${DEBIAN_PACKAGES[fonts]}
            ;;
            
        fedora|rhel|centos|rocky|almalinux)
            # Install packages using dnf
            sudo dnf install -y ${FEDORA_PACKAGES[software]} ${FEDORA_PACKAGES[fonts]}
            ;;
            
        opensuse-leap|opensuse-tumbleweed)
            sudo zypper install -y ${OPEN_SUSE_PACKAGES[software]} ${OPEN_SUSE_PACKAGES[fonts]}
            ;;
            
        *)
            echo "Unsupported distribution: $DISTRO_ID"
            echo "Please install dependencies manually:"
            echo "Software: ${ARCH_PACKAGES[software]}"
            echo "Fonts: ${ARCH_PACKAGES[fonts]}"
            return 1
            ;;
    esac

    # Handle npm packages separately
    if command -v npm &> /dev/null; then
        if ! command -v ncu &> /dev/null; then
            echo "Installing npm-check-updates (ncu)..."
            npm install -g npm-check-updates
        fi
    fi

    # Handle python pip packages separately
    if command -v pip &> /dev/null; then
        if ! command -v colorthief &> /dev/null && pip show colorthief &> /dev/null; then
            echo "Installing colorthief via pip..."
            pip install colorthief
        fi
    fi

    # Additional setup for different distributions
    case $DISTRO_ID in
        ubuntu|debian|mint)
            # Enable services for Debian-based systems
            systemctl --user enable --now sway-session.target 2>/dev/null || true
            ;;
        fedora)
            # Enable services for Fedora
            systemctl --user enable --now sway-session.target 2>/dev/null || true
            ;;
    esac

    echo "Dependencies installation completed. Please check for errors."
}

deploy_dotfiles() {
    echo "Deploying dotfiles to ~/.config/..."
    local SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
    
    # Create backup of existing configs if they exist
    if [ -d "$HOME/.config/sway" ]; then
        echo "Backing up existing sway config..."
        mv "$HOME/.config/sway" "$HOME/.config/sway_backup_$(date +%Y%m%d_%H%M%S)"
    fi
    
    if [ -d "$HOME/.config/nushell" ]; then
        echo "Backing up existing nushell config..."
        mv "$HOME/.config/nushell" "$HOME/.config/nushell_backup_$(date +%Y%m%d_%H%M%S)"
    fi

    # Ensure ~/.config exists
    mkdir -p "$HOME/.config"

    # Copy config directories
    rsync -avh --exclude 'install.sh' --exclude 'README.md' --exclude '.git' "$SCRIPT_DIR/" "$HOME/.config/"
    
    # Special handling for nushell config
    if [ -d "$SCRIPT_DIR/nushell" ]; then
        cp -r "$SCRIPT_DIR/nushell" "$HOME/.config/"
    fi

    # Check for distro-specific overrides
    if [ -d "$SCRIPT_DIR/distro-configs/$DISTRO_ID" ]; then
        echo "Applying $DISTRO_ID-specific configurations..."
        rsync -avh "$SCRIPT_DIR/distro-configs/$DISTRO_ID/" "$HOME/.config/"
    fi

    echo "Dotfiles deployment complete."
    
    # Create symlinks for shell configurations if needed
    if [ -f "$HOME/.config/nushell/config.nu" ] && [ ! -f "$HOME/.config/nushell/config.nu" ]; then
        echo "Setting up nushell configuration..."
        mkdir -p "$HOME/.config/nushell"
        ln -sf "$HOME/.config/nushell/config.nu" "$HOME/.config/nushell/config.nu" 2>/dev/null || true
    fi
}

setup_additional_features() {
    echo "Setting up additional features..."
    
    # Create necessary directories
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/Pictures/Wallpapers"
    
    # Setup XDG user directories
    xdg-user-dirs-update 2>/dev/null || true
    
    # Setup wpgtk if available
    if command -v wpg &> /dev/null; then
        echo "Setting up wpgtk..."
        mkdir -p "$HOME/.config/wpg"
        # Copy wallpapers if they exist
        if [ -d "$HOME/.config/wpg/wallpapers" ]; then
            wpg-install.sh 2>/dev/null || true
        fi
    fi
    
    # Setup autostart scripts
    mkdir -p "$HOME/.config/autostart"
    
    echo "Additional features setup complete."
}

# --- Main execution ---
echo "This script will help you set up your Sway/Nushell dotfiles."
echo "Distribution detected: $DISTRO ($DISTRO_ID)"
echo "Package manager: $PKG_MANAGER"
echo ""
echo "Dependencies will be installed and configuration files will be deployed."
echo ""

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

read -p "Do you want to setup additional features? (y/N): " feature_choice
if [[ "$feature_choice" =~ ^[Yy]$ ]]; then
    setup_additional_features
fi

echo ""
echo "Setup script finished. Please reboot or log out for changes to take effect."
echo "Remember to source your shell configuration files (e.g., .bashrc, .zshrc, config.nu) if they were just moved."
echo ""
echo "To start sway: sway"
echo "To start waybar: waybar &"
echo "To reload sway config: swaymsg reload"
