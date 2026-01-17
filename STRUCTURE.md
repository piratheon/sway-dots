# Repository Structure

This document explains the organization of the dotfiles repository.

## Main Directories

```
/workspace/
├── alacritty/          # Alacritty terminal emulator config
├── eww/               # EWW (Elkowar's Wacky Widgets) config
├── fastfetch/         # Fastfetch system info tool config
├── foot/              # Foot terminal emulator config
├── kitty/             # Kitty terminal emulator config
├── mako/              # Mako notification daemon config
├── nushell/           # Nushell configuration
├── nwg-bar/           # NWG bar config
├── nwg-launchers/     # NWG launchers config
├── nwg-panel/         # NWG panel config
├── nwg-wrapper/       # NWG wrapper config
├── rofi/              # Rofi application launcher config
├── sway/              # Sway window manager config
├── waybar/            # Waybar status bar config
├── wayfire/           # Wayfire compositor config
├── wlogout/           # Wlogout session menu config
├── wofi/              # Wofi application launcher config
├── wpg/               # WPGTK wallpaper theming config
├── distro-configs/    # Distribution-specific overrides
│   ├── arch/          # Arch Linux specific configs
│   ├── debian/        # Debian/Ubuntu specific configs
│   └── fedora/        # Fedora specific configs
├── install.sh         # Main installation script
├── README.md          # Main documentation
└── STRUCTURE.md       # This file
```

## Distribution-Specific Configurations

The `distro-configs/` directory contains configuration overrides for specific Linux distributions. During installation, if a matching directory exists for the detected distribution, those files will be applied after the main configurations.

### How It Works

1. Main configuration files are copied from the root directories (e.g., `/sway/`, `/waybar/`)
2. If a distribution-specific version exists in `distro-configs/<distro>/`, those files override the main ones
3. This allows for distribution-specific paths, packages, or settings while maintaining a common base

### Adding New Distributions

To add support for a new distribution:

1. Create a new directory under `distro-configs/` with the distribution ID
2. Add configuration files that differ from the main ones
3. The install script will automatically detect and apply these during installation

## File Organization Principles

- Each application gets its own directory named after the application
- Configuration files are placed directly in the application's directory
- Subdirectories are used only when required by the application's configuration structure
- Distribution-specific overrides only contain differences from the main configuration