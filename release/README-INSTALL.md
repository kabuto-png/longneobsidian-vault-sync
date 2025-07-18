# Vault Sync Plugin - Installation Package

## 📦 What's included:

```
vault-sync/                 # Plugin files
├── main.js                 # Plugin code
├── manifest.json           # Plugin manifest
└── styles.css              # Plugin styles (if any)

scripts/
├── windows/                # Windows sync scripts
│   ├── sync-vault.bat      # Windows batch script
│   └── sync-vault.ps1      # PowerShell script
└── unix/                   # Unix/macOS/Linux scripts
    ├── sync-vault.sh       # Basic sync script
    └── sync-vault-optimized.sh  # Recommended script

INSTALL-WINDOWS.bat         # Windows installer
install-unix.sh             # Unix/macOS installer
INSTALLATION.md             # Detailed installation guide
```

## 🚀 Quick Install:

### Windows:
1. Double-click `INSTALL-WINDOWS.bat`
2. Enter your vault path when prompted
3. Open Obsidian and enable the plugin

### Unix/macOS/Linux:
1. Run `chmod +x install-unix.sh && ./install-unix.sh`
2. Enter your vault path when prompted
3. Open Obsidian and enable the plugin

## 📖 Detailed Instructions:
See `INSTALLATION.md` for complete setup guide.

## 🔧 Manual Installation:
1. Copy `vault-sync/` folder to `YourVault/.obsidian/plugins/`
2. Copy appropriate sync script to your vault root
3. Enable plugin in Obsidian settings
