#!/bin/bash

# This script installs dotfiles and their dependencies with support for multiple distributions.
# Please review the script before running it.

# --- Global Variables ---
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
DISTRO=""
PKG_MANAGER=""
UI_BLUR_ENABLED=true
KEYBOARD_LAYOUTS=("fr")
CUSTOMIZE_KEYBOARD=false

# --- Distro Detection ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
        case $ID in
            arch|manjaro|garuda)
                PKG_MANAGER="paru"
                ;;
            ubuntu|debian|mint)
                PKG_MANAGER="apt"
                ;;
            fedora)
                PKG_MANAGER="dnf"
                ;;
            opensuse*)
                PKG_MANAGER="zypper"
                ;;
            *)
                echo "Unsupported distribution: $ID"
                echo "Defaulting to Arch Linux setup"
                PKG_MANAGER="paru"
                DISTRO="arch"
                ;;
        esac
    else
        echo "Could not detect distribution, defaulting to Arch Linux setup"
        PKG_MANAGER="paru"
        DISTRO="arch"
    fi

    echo "Detected distribution: $DISTRO"
    echo "Using package manager: $PKG_MANAGER"
}

# --- Package Lists per Distribution ---
get_arch_packages() {
    echo "alacritty audio-recorder autotiling avizo bat blueman btop brightnessctl curl dunst eww eza expac fastfetch ffmpeg flatpak foot gedit glow grim grimshot hwinfo imagemagick jq kvantum libinput-gestures libnotify lxappearance mako networkmanager networkmanager-applet networkmanager-dmenu netcat neovim ori pamac pavucontrol pcmanfm playerctl polkit-gnome poweralertd procps-ng python qt5ct ranger reflector ripgrep rofi slurp swayfx swayidle swaylock swww tracker translate-shell urxvt vimcat volumectl waybar waybar-mpris wget wlogout wofi wpg xsettingsd xdg-user-dirs xdg-utils xsane yad"
}

get_debian_packages() {
    echo "alacritty wl-clipboard bat blueman btop brightnessctl curl dunst eza fastfetch ffmpeg flatpak foot gedit glow grim swayshot hwinfo imagemagick jq libinput-tools libnotify-bin lxappearance mako network-manager network-manager-gnome netcat-openbsd neovim pcmanfm playerctl procps python3 qt5ct ranger reflector ripgrep rofi slurp swayidle swaylock-effects swww tracker translate-shell vim-gtk3 waybar wget wlogout wofi xsettingsd xdg-user-dirs xdg-utils xsane-gtk yad"
}

get_fedora_packages() {
    echo "alacritty wl-clipboard bat blueman btop brightnessctl curl dunst eza fastfetch ffmpeg flatpak foot gedit glow grim swayshot hwinfo ImageMagick jq libinput libnotify lxappearance mako NetworkManager NetworkManager-tui nmap-ncat neovim pavucontrol pcmanfm playerctl procps-ng python3 qt5ct ranger ripgrep rofi slurp swayidle swaylock swww tracker translate-shell vim-enhanced waybar wget wlogout wofi xsettingsd xdg-user-dirs xdg-utils xsane yad"
}

get_font_packages() {
    case $DISTRO in
        arch|manjaro|garuda)
            echo "ttf-jetbrains-mono-nerd ttf-meslo-lgs-nerd noto-fonts ttf-hack-fonts"
            ;;
        ubuntu|debian|mint)
            echo "fonts-noto-color-emoji fonts-jetbrains-mono fonts-liberation fonts-dejavu-core fonts-freefont-ttf fonts-hack-ttf"
            ;;
        fedora)
            echo "jetbrains-mono-fonts liberation-fonts dejavu-sans-fonts hack-fonts google-noto-emoji-fonts"
            ;;
        *)
            echo "ttf-jetbrains-mono-nerd ttf-meslo-lgs-nerd noto-fonts ttf-hack-fonts"
            ;;
    esac
}

# --- User Prompts ---
ask_user_preferences() {
    echo ""
    echo "=== Customization Options ==="

    # UI Blur Option
    read -p "Enable UI blur effects? (y/N): " blur_choice
    if [[ "$blur_choice" =~ ^[Yy]$ ]]; then
        UI_BLUR_ENABLED=true
        echo "UI blur will be enabled"
    else
        UI_BLUR_ENABLED=false
        echo "UI blur will be disabled"
    fi

    # Keyboard Layout Option
    read -p "Would you like to customize keyboard layouts? (y/N): " keyboard_choice
    if [[ "$keyboard_choice" =~ ^[Yy]$ ]]; then
        CUSTOMIZE_KEYBOARD=true
        read -p "Enter keyboard layouts (comma separated, e.g., 'us,fr,de'): " keyboard_input
        IFS=',' read -ra KEYBOARD_LAYOUTS <<< "$keyboard_input"
        echo "Keyboard layouts set to: ${KEYBOARD_LAYOUTS[*]}"
    else
        CUSTOMIZE_KEYBOARD=false
        echo "Using default keyboard layout (fr)"
    fi
}

# --- Functions ---
install_dependencies() {
    echo "Attempting to install software dependencies for $DISTRO..."

    # Get appropriate package lists
    case $DISTRO in
        arch|manjaro|garuda)
            SOFTWARE_PACKAGES=$(get_arch_packages)
            FONT_PACKAGES=$(get_font_packages)
            if [[ "$PKG_MANAGER" == "paru" || "$PKG_MANAGER" == "yay" ]]; then
                sudo "$PKG_MANAGER" -Syu --needed --noconfirm $SOFTWARE_PACKAGES $FONT_PACKAGES
            elif [[ "$PKG_MANAGER" == "pacman" ]]; then
                sudo "$PKG_MANAGER" -Syu --needed --noconfirm $SOFTWARE_PACKAGES $FONT_PACKAGES
                echo "WARNING: Some packages might be from AUR. Please install them manually using an AUR helper like paru/yay or from source."
            fi
            ;;
        ubuntu|debian|mint)
            SOFTWARE_PACKAGES=$(get_debian_packages)
            FONT_PACKAGES=$(get_font_packages)
            sudo apt update
            sudo apt install -y $SOFTWARE_PACKAGES $FONT_PACKAGES
            ;;
        fedora)
            SOFTWARE_PACKAGES=$(get_fedora_packages)
            FONT_PACKAGES=$(get_font_packages)
            sudo dnf update -y
            sudo dnf install -y $SOFTWARE_PACKAGES $FONT_PACKAGES
            ;;
        *)
            echo "Unsupported distribution: $DISTRO"
            return 1
            ;;
    esac

    # Handle npm-check-updates separately as it's an npm package
    if ! command -v ncu &> /dev/null; then
        echo "Installing npm-check-updates (ncu)..."
        npm install -g npm-check-updates
    fi

    # Handle python pip packages separately
    if ! command -v colorthief &> /dev/null && pip3 show colorthief &> /dev/null; then
        echo "Installing colorthief via pip3..."
        pip3 install colorthief
    fi

    echo "Dependencies installation attempted. Please check for errors."
}

prepare_configs() {
    echo "Preparing configuration files..."

    # Create temporary directory for modified configs
    TEMP_CONFIG_DIR=$(mktemp -d)

    # Copy all configs to temp directory
    cp -r "$SCRIPT_DIR"/* "$TEMP_CONFIG_DIR/"

    # Modify sway config based on UI blur preference
    if [ "$UI_BLUR_ENABLED" = false ]; then
        echo "Disabling blur effects in sway config..."
        # Create a version without blur effects by commenting out blur-related lines
        sed 's/^\(.*blur.*enable\)/# \1/' "$TEMP_CONFIG_DIR/sway/config.d/swayfx" | sed 's/^\(blur.*enable\)/# \1/' > "$TEMP_CONFIG_DIR/sway/config.d/swayfx.tmp" && mv "$TEMP_CONFIG_DIR/sway/config.d/swayfx.tmp" "$TEMP_CONFIG_DIR/sway/config.d/swayfx"
    fi

    # Modify input config based on keyboard layout preference
    if [ "$CUSTOMIZE_KEYBOARD" = true ]; then
        echo "Updating keyboard layouts in sway config..."
        # Build the xkb_layout line with all selected layouts
        LAYOUTS_STR=$(IFS=,; echo "${KEYBOARD_LAYOUTS[*]}")

        # Update the xkb_layout in input config
        sed "s/xkb_layout \"fr\"/xkb_layout \"$LAYOUTS_STR\"/g; s/xkb_options \"grp:alt_shift_toggle,caps:escape\"/xkb_options \"grp:alt_shift_toggle,caps:escape\"/g" \
            "$TEMP_CONFIG_DIR/sway/config.d/input" > "$TEMP_CONFIG_DIR/sway/config.d/input.tmp" && mv "$TEMP_CONFIG_DIR/sway/config.d/input.tmp" "$TEMP_CONFIG_DIR/sway/config.d/input"
    fi

    # Copy modified configs to home directory
    echo "Deploying dotfiles to ~/.config/..."
    mkdir -p "$HOME/.config"

    # Use rsync to copy configs, excluding install script and README
    rsync -avh --exclude 'install.sh' --exclude 'README.md' --exclude '.git' "$TEMP_CONFIG_DIR/" "$HOME/.config/"

    # Clean up temp directory
    rm -rf "$TEMP_CONFIG_DIR"

    # Special handling for nushell config
    if [ -d "$HOME/.config/nushell" ]; then
        mv "$HOME/.config/nushell" "$HOME/.config/nushell_backup_$(date +%Y%m%d_%H%M%S)" || true
    fi

    # Use distribution-specific nushell config if available
    if [ -f "$SCRIPT_DIR/distro-configs/$DISTRO/nushell/config.nu" ]; then
        mkdir -p "$HOME/.config/nushell"
        cp "$SCRIPT_DIR/distro-configs/$DISTRO/nushell/config.nu" "$HOME/.config/nushell/config.nu"
    else
        cp -r "$SCRIPT_DIR/nushell" "$HOME/.config/"
    fi

    echo "Configuration files deployed successfully!"
}

# --- Main execution ---
echo "This script will help you set up your Sway/Nushell dotfiles."
echo "It will detect your distribution and install appropriate packages."

# Detect distribution and set package manager
detect_distro

# Ask user for preferences
ask_user_preferences

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
    prepare_configs
fi

echo "Setup script finished. Please reboot or log out for changes to take effect."
echo "Remember to source your shell configuration files (e.g., .bashrc, .zshrc, config.nu) if they were just moved."
