# Changelog

All notable changes to the Vault Sync plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- TypeScript support for better code quality
- Enhanced error handling and type safety
- Improved documentation and examples
- GitHub Actions for automated releases
- ESLint and Prettier configuration
- iCloud coordination support for mobile-desktop sync
- Coordinated sync script with device switching
- Mobile-desktop conflict prevention

### Changed
- Migrated from JavaScript to TypeScript
- Generic plugin name (removed "Longneobsidian" hardcoding)
- Improved code structure and organization
- Better cross-platform compatibility

### Fixed
- Type safety issues in settings management
- Status bar click handler type definitions
- Memory leak in auto-sync interval management

## [2.1.0] - 2025-06-03

### Added
- Real-time status bar with sync information
- Clickable status bar for detailed information
- Sync counter with persistent storage
- Enhanced settings panel with live status display
- Sync duration tracking and display
- Multiple sync script support (basic/advanced/optimized)
- Reset counter functionality
- Improved notification system

### Changed
- Enhanced UI with better visual feedback
- Improved error handling and user messaging
- Better settings organization and layout
- More comprehensive status information

### Fixed
- Auto-sync interval management
- Status bar update timing
- Settings persistence across restarts
- Plugin loading and unloading issues

## [2.0.0] - 2025-06-01

### Added
- Auto-sync functionality with configurable intervals
- Status tracking and display
- Settings panel for configuration
- Command palette integration
- Ribbon icon for manual sync
- Persistent sync counter
- Timestamp tracking for last sync
- Notification system for sync status

### Changed
- Complete rewrite from v1.0.0
- Improved plugin architecture
- Better error handling and recovery
- Enhanced user interface

### Removed
- Basic sync-only functionality
- Hardcoded configuration options

## [1.0.0] - 2025-05-01

### Added
- Initial release
- Basic Git synchronization
- Manual sync functionality
- Simple settings interface
- Command palette support

### Features
- Manual vault synchronization
- Basic Git operations (add, commit, push)
- Simple notification system
- Minimal configuration options

---

## Version History Summary

- **v2.1.0** - Status bar, sync counter, enhanced UI
- **v2.0.0** - Auto-sync, comprehensive settings, improved architecture
- **v1.0.0** - Initial release, basic sync functionality

## Upgrade Guide

### From v2.0.0 to v2.1.0
- No breaking changes
- New features available immediately
- Settings are preserved
- Status bar appears automatically

### From v1.0.0 to v2.0.0
- **Breaking changes**: Complete rewrite
- **Settings migration**: Manual reconfiguration required
- **New features**: Auto-sync, status tracking, enhanced UI
- **Backup**: Export settings before upgrade

## Future Roadmap

### v2.2.0 (Planned)
- [ ] Multiple remote support
- [ ] Conflict resolution UI
- [ ] Sync scheduling (specific times)
- [ ] Detailed sync history
- [ ] Performance optimizations

### v3.0.0 (Planned)
- [ ] Cloud service integration
- [ ] Real-time collaboration features
- [ ] Advanced conflict resolution
- [ ] Plugin API for extensibility
- [ ] Mobile app support

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### How to Report Issues
1. Check existing issues first
2. Use the issue template
3. Include version information
4. Provide detailed reproduction steps
5. Add relevant logs and screenshots

### How to Suggest Features
1. Check existing feature requests
2. Use the feature request template
3. Explain the use case and benefits
4. Provide mockups if applicable
5. Consider implementation complexity

## Support

For questions and support:
- 📚 [Documentation](README.md)
- 🐛 [Issue Tracker](https://github.com/kabuto-png/longneobsidian-vault-sync/issues)
- 💬 [Discussions](https://github.com/kabuto-png/longneobsidian-vault-sync/discussions)
- 📧 [Email Support](mailto:kabuto.png@gmail.com)
