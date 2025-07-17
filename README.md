# Vault Sync - Obsidian Plugin

A powerful Obsidian plugin for Git vault synchronization with auto-sync capabilities, real-time status tracking, and comprehensive time information.

![Plugin Version](https://img.shields.io/badge/version-2.1.0-blue)
![Obsidian Version](https://img.shields.io/badge/obsidian-0.15.0%2B-purple)
![License](https://img.shields.io/badge/license-MIT-green)

## ✨ Features

### 🔄 Auto-Sync Capabilities
- **Configurable intervals** - Set sync frequency from 1-60 minutes
- **Background operation** - Non-intrusive automatic syncing
- **One-click toggle** - Enable/disable via command palette or settings
- **Persistent settings** - Configuration survives Obsidian restarts

### 📊 Real-Time Status Tracking
- **Live status bar** - Shows sync status at bottom of Obsidian
- **Sync counter** - Persistent count of successful syncs
- **Last sync timestamp** - Human-readable format ("5m ago", "2h ago")
- **Sync duration tracking** - Performance timing for each operation
- **Clickable status bar** - Click for detailed information

### 🎛️ Comprehensive Control
- **Multiple sync scripts** - Choose between basic/advanced/optimized/coordinated
- **iCloud coordination** - Mobile-desktop sync with conflict prevention
- **Manual sync** - Trigger immediate sync via ribbon or command
- **Notification control** - Enable/disable sync status messages
- **Status modal** - Detailed sync information display
- **Device coordination** - Seamless switching between devices

## 📦 Installation

### From GitHub Releases (Recommended)
1. Download the latest release from [GitHub Releases](https://github.com/kabuto-png/longneobsidian-vault-sync/releases)
2. Extract the files to your `.obsidian/plugins/vault-sync/` directory
3. Enable the plugin in Obsidian Settings → Community plugins

### Manual Installation
1. Clone this repository
2. Run `npm install` to install dependencies
3. Run `npm run build` to build the plugin
4. Copy `main.js`, `manifest.json`, and `styles.css` to your `.obsidian/plugins/vault-sync/` directory

## 🚀 Quick Start

### 1. Prerequisites
- **Git repository** - Your vault must be a Git repository
- **Sync script** - One of the supported sync scripts in your vault root
- **Git remote** - Configured remote repository for syncing

### 2. Sync Scripts
Create one of these scripts in your vault root directory:

**Basic Script (`sync-vault.sh`)**:
```bash
#!/bin/bash
git add .
git commit -m "$1"
git push origin main
```

**Advanced Script (`sync-vault-advanced.sh`)**:
```bash
#!/bin/bash
cd "$(dirname "$0")"
git add .
if git commit -m "$1"; then
    git push origin main
    echo "Sync completed successfully"
else
    echo "No changes to commit"
fi
```

**Optimized Script (`sync-vault-optimized.sh`)** (Recommended):
```bash
#!/bin/bash
set -e
cd "$(dirname "$0")"

# Check if we're in a git repo
if [ ! -d .git ]; then
    echo "Error: Not a git repository"
    exit 1
fi

# Pull latest changes
git pull origin main --rebase

# Add and commit local changes
git add .
if git commit -m "$1"; then
    # Push changes
    git push origin main
    echo "Sync completed successfully"
else
    echo "No changes to commit"
fi
```

**Coordinated Script (`sync-vault-coordinated.sh`)** (iCloud Support):
```bash
#!/bin/bash
set -e
cd "$(dirname "$0")"

# iCloud coordination for mobile-desktop sync
# - Detects recent iCloud activity
# - Coordinates device switches
# - Waits for iCloud to settle
# - Handles mobile-desktop conflicts

# Check iCloud activity and coordinate
echo "🔄 Starting coordinated vault sync with iCloud support..."
# [Full implementation in examples/sync-vault-coordinated.sh]
```

### 3. Enable Plugin
1. Go to **Settings** → **Community plugins**
2. Find **"Vault Sync"** and **toggle ON**
3. Configure settings as needed

## 🎮 Usage

### Status Bar
The plugin displays real-time sync status in the bottom status bar:

**Auto-sync Enabled:**
```
🔄 Auto: 5m | 2m ago | 47
```
- `🔄 Auto: 5m` = Auto-sync every 5 minutes
- `2m ago` = Last sync 2 minutes ago
- `47` = 47 total successful syncs

**Manual Mode:**
```
⏸️ Manual | Never | 0
```
- `⏸️ Manual` = Auto-sync disabled
- `Never` = No syncs performed yet
- `0` = Zero syncs completed

**Click the status bar** for detailed information popup.

### Commands
Access these commands via **Ctrl+P** (Command Palette):

1. **`Sync Vault (Manual)`** - Trigger immediate sync
2. **`Toggle Auto-Sync`** - Enable/disable automatic syncing
3. **`View Sync Status`** - Show detailed status information

### Settings Panel
Configure the plugin in **Settings → Community plugins → Vault Sync**:

- **Sync Script** - Choose your preferred sync script
- **Auto-sync** - Enable/disable automatic syncing
- **Interval** - Set sync frequency (1-60 minutes)
- **Notifications** - Control sync status messages
- **Actions** - Manual sync, status view, counter reset

## ⚙️ Configuration

### Sync Script Options
- **Basic** - Simple Git operations
- **Advanced** - Enhanced with error handling
- **Optimized** - Full-featured with conflict resolution ⭐ **Recommended**
- **With iCloud** - Mobile-desktop coordination with iCloud support 📱 **New!**

### Auto-Sync Settings
- **Interval Range** - 1 to 60 minutes
- **Background Operation** - Runs automatically without interruption
- **Visual Feedback** - Status bar shows current mode and countdown

### Notification Options
- **Sync Start** - "🔄 Starting vault sync..."
- **Sync Success** - "✅ Synced! (2.3s)"
- **No Changes** - "ℹ️ No changes to sync (1.1s)"
- **Sync Error** - "❌ Sync failed: [error message]"

## 🔧 Troubleshooting

### Common Issues

#### Plugin Won't Load
- **Restart Obsidian** completely
- **Check plugin files** exist in `.obsidian/plugins/vault-sync/`
- **Verify permissions** on sync script: `chmod +x sync-vault.sh`

#### Auto-sync Not Working
- **Check settings** - Ensure auto-sync is enabled
- **Verify status bar** - Should show "🔄 Auto: Xm" not "⏸️ Manual"
- **Script permissions** - Ensure bash script is executable
- **Git repository** - Confirm vault is a Git repository

#### Sync Failures
- **Check internet connection**
- **Verify Git remote** accessibility
- **Resolve merge conflicts** manually
- **Check script paths** and permissions

### Debug Information
Enable **Developer Console** (F12) to see detailed logs:
```
Loading Vault Sync Plugin...
Vault Sync Plugin loaded successfully
```

## 📈 Performance

### Resource Usage
- **Memory** - Minimal footprint (~1MB)
- **CPU** - Low impact, only active during sync
- **Network** - Depends on vault size and change frequency
- **Storage** - Small settings file only

### Optimization Tips
- **Choose appropriate interval** - Balance between freshness and performance
- **Use optimized script** - Better error handling and conflict resolution
- **Monitor sync duration** - Displayed in notifications
- **Regular Git maintenance** - Periodic repository cleanup

## 🤝 Contributing

We welcome contributions! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Setup
```bash
# Clone the repository
git clone https://github.com/kabuto-png/longneobsidian-vault-sync.git
cd longneobsidian-vault-sync

# Install dependencies
npm install

# Start development build
npm run dev

# Build for production
npm run build
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Obsidian Team** - For the excellent plugin API
- **Git** - For reliable version control
- **Community** - For feedback and feature requests

## 📞 Support

- **GitHub Issues** - [Report bugs or request features](https://github.com/kabuto-png/longneobsidian-vault-sync/issues)
- **Discussions** - [Community discussions](https://github.com/kabuto-png/longneobsidian-vault-sync/discussions)
- **Email** - [Contact the author](mailto:kabuto.png@gmail.com)

---

⭐ **Star this repository** if you find it useful!

Made with ❤️ by [kabuto-png](https://github.com/kabuto-png)
