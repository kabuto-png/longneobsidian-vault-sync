# Obsidian Vault Sync - Universal Cross-Platform Solution

🚀 **One-command setup for Windows, macOS, and Linux users**

## Quick Install

### Method 1: One-Line Install (Recommended)
```bash
# Navigate to your Obsidian vault directory, then run:
bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)
```

### Method 2: Manual Download
```bash
# Clone the repository
git clone https://github.com/kabuto-png/longneobsidian-vault-sync.git
cd longneobsidian-vault-sync

# Run installer
./install.sh
```

## What This Does

✅ **Auto-detects your operating system**  
✅ **Downloads appropriate sync scripts**  
✅ **Sets up Git configuration**  
✅ **Creates proper .gitignore for Obsidian**  
✅ **Tests installation automatically**  

## Supported Platforms

| Platform | Scripts Installed |
|----------|------------------|
| **Windows** | PowerShell (.ps1), Batch (.bat), WSL (.bat) |
| **macOS** | Bash (.sh) |
| **Linux** | Bash (.sh) |

## After Installation

1. **Install Obsidian sync plugin** (e.g., "Obsidian Git")
2. **Configure plugin**: Set sync script to `sync-vault-coordinated.sh`
3. **Test sync**: Run `./sync-vault-coordinated.sh` manually

## How It Works

The installer creates a **universal wrapper** (`sync-vault-coordinated.sh`) that:

- Automatically detects your OS
- Runs the best script for your platform  
- Provides colored status output
- Handles errors gracefully

### Windows Priority
```
1st Choice: sync-vault.ps1    (PowerShell - recommended)
2nd Choice: sync-vault.bat    (Windows Batch)  
3rd Choice: sync-vault-wsl.bat (WSL wrapper)
```

### macOS/Linux
```
Uses: sync-vault.sh (standard bash)
```

## Troubleshooting

### Installation Issues
```bash
# Check if you're in the right directory
ls -la | grep .obsidian

# Make sure you have internet connection
curl -s https://github.com

# Run with verbose output
bash -x install.sh
```

### Sync Issues
```bash
# Test the wrapper manually
./sync-vault-coordinated.sh

# Check file permissions
ls -la sync-vault*

# Make executable if needed
chmod +x sync-vault-coordinated.sh
```

### Plugin Not Detecting Scripts
1. Restart Obsidian
2. Disable/enable the sync plugin
3. Ensure scripts are in vault root (same level as `.obsidian/`)

## Manual Setup (Advanced Users)

If you prefer manual setup:

1. Copy `sync-vault-coordinated.sh` to your vault root
2. Copy platform-specific scripts:
   - **Windows**: Choose one of `sync-vault.ps1`, `sync-vault.bat`, or `sync-vault-wsl.bat`
   - **macOS/Linux**: Copy `sync-vault.sh`
3. Make scripts executable: `chmod +x *.sh`
4. Configure your Obsidian sync plugin

## Requirements

- **Git** installed on your system
- **Obsidian** with a sync plugin (e.g., Obsidian Git)
- **Internet connection** for installation

## Installation Locations

The installer looks for vaults in these common locations:
- `~/Documents/Obsidian`
- `~/Documents` 
- `~/Library/Mobile Documents/iCloud~md~obsidian/Documents` (macOS)
- `~/Dropbox`
- `~/OneDrive`
- Current directory

## Contributing

Found a bug or want to improve the installer? 
1. Fork this repository
2. Create your feature branch
3. Submit a pull request

## License

MIT License - feel free to use and modify!

---

**Need help?** [Open an issue](https://github.com/kabuto-png/longneobsidian-vault-sync/issues) or check our [troubleshooting guide](./TROUBLESHOOTING.md).
