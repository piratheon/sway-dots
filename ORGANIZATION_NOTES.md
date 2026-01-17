# Repository Organization Notes

## Structure Overview

```
/workspace/
├── install.sh                    # Main installation script (improved)
├── README.md                     # Updated documentation
├── ORGANIZATION_NOTES.md         # This file
├── distro-configs/               # Distribution-specific configurations
│   ├── arch/
│   │   ├── packages.txt          # Arch package list
│   │   └── [app configs]         # Arch-specific app configs (if needed)
│   ├── debian/
│   │   ├── packages.txt          # Debian package list
│   │   └── [app configs]         # Debian-specific app configs (if needed)
│   └── fedora/
│       ├── packages.txt          # Fedora package list
│       └── [app configs]         # Fedora-specific app configs (if needed)
├── alacritty/                    # Original app configs remain here
├── eww/
├── fastfetch/
├── foot/
├── kitty/
├── mako/
├── nushell/
├── nwg-bar/
├── nwg-launchers/
├── nwg-panel/
├── nwg-wrapper/
├── rofi/
├── sway/
├── waybar/
├── wayfire/
├── wlogout/
├── wofi/
├── wpg/
└── [other app configs]/
```

## Key Improvements Made

### 1. Enhanced install.sh Script
- Added distribution detection
- Added support for Arch, Debian, Ubuntu, Fedora, openSUSE
- Added user prompts for UI blur and keyboard layouts
- Created dynamic package installation based on detected distro
- Added proper error handling

### 2. Distribution-Specific Package Lists
- Created separate package lists for each supported distribution
- Each list contains appropriate package names for that ecosystem

### 3. Configuration Customization
- UI blur can be toggled during installation
- Keyboard layouts can be customized during installation
- Configuration files are processed before deployment

### 4. Improved Documentation
- Updated README with new features and installation instructions
- Added information about supported distributions
- Documented customization options

## How the Installation Works

1. The script detects your Linux distribution using `/etc/os-release`
2. It presents customization options (UI blur, keyboard layouts)
3. It installs appropriate packages based on your distribution
4. It processes configuration files based on your choices
5. It deploys the configurations to `~/.config/`

## App Configuration Handling

The original app configurations remain in the root of the repository. During installation:
- Files are copied to a temporary directory
- Configurations are modified based on user preferences
- Modified files are deployed to `~/.config/`

This maintains the original structure while enabling distribution-specific installations.