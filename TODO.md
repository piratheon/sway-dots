# TODO List

## High Priority
- [ ] Test install script on actual Debian/Fedora systems
- [ ] Verify all package names are correct for each distribution
- [ ] Add error handling for missing dependencies
- [ ] Add rollback functionality in case of installation failure

## Medium Priority
- [ ] Add more distribution support (Alpine, Gentoo, etc.)
- [ ] Create configuration validation checks
- [ ] Add backup/restore functionality for existing configs
- [ ] Implement dry-run mode for the installer
- [ ] Add option to select specific components to install

## Low Priority
- [ ] Create uninstaller script
- [ ] Add systemd service files where appropriate
- [ ] Create post-installation optimization scripts
- [ ] Add theme selection options during installation
- [ ] Document all configuration options in README

## Security Considerations
- [ ] Validate user inputs in install script
- [ ] Add checksum verification for critical files
- [ ] Sanitize file permissions after installation

## Testing
- [ ] Create test suite for configuration validity
- [ ] Test on clean VMs of each supported distribution
- [ ] Verify all keybindings and functionality work