# Universal Obsidian Vault Sync Wrapper

## Overview
This universal wrapper script (`sync-vault-coordinated.sh`) automatically detects your operating system and runs the appropriate sync script for your platform.

## Features
- **Auto OS Detection**: Windows, macOS, Linux support
- **Smart Script Selection**: Prioritizes best script for each platform
- **Colored Output**: Clear status messages with color coding
- **Error Handling**: Comprehensive error checking and reporting
- **Cross-Platform**: Single script works everywhere

## Installation

### 1. Copy Required Scripts
Copy the wrapper and your platform-specific scripts to your vault root directory:

```
your-vault/
├── .obsidian/
├── sync-vault-coordinated.sh    ← Universal wrapper (required)
└── [Platform-specific scripts below]
```

### 2. Platform-Specific Scripts

#### Windows Users
Choose ONE of these scripts and copy to vault root:
- `sync-vault.ps1` - **Recommended** (PowerShell with better error handling)
- `sync-vault.bat` - Basic Windows batch script
- `sync-vault-wsl.bat` - WSL wrapper for bash scripts

#### macOS/Linux Users
- `sync-vault.sh` - Standard bash script

### 3. Configure Obsidian Plugin
1. Go to Settings → Community Plugins → [Your Sync Plugin]
2. Set Sync Script to: `sync-vault-coordinated.sh`
3. The wrapper will auto-detect your OS and run the correct script

## How It Works

### Detection Logic
```
Windows (MSYS/Win32/Windows_NT)
├── sync-vault.ps1 (Priority 1 - PowerShell)
├── sync-vault.bat (Priority 2 - Batch)
└── sync-vault-wsl.bat (Priority 3 - WSL)

macOS (darwin)
└── sync-vault.sh (bash)

Linux
└── sync-vault.sh (bash)

Unknown OS
└── sync-vault.sh (fallback)
```

### Output Colors
- 🔵 **Blue [INFO]**: General information
- 🟢 **Green [SUCCESS]**: Operation completed successfully  
- 🟡 **Yellow [WARNING]**: Non-critical issues
- 🔴 **Red [ERROR]**: Critical errors

## Troubleshooting

### Script Not Detected in Plugin
1. Ensure `sync-vault-coordinated.sh` is in vault root (same level as `.obsidian/`)
2. Restart Obsidian or disable/enable the sync plugin
3. Check file permissions (should be executable)

### Windows: Script Execution Errors
```bash
# Make script executable (if needed)
icacls sync-vault-coordinated.sh /grant Everyone:F

# For PowerShell execution issues
powershell.exe -ExecutionPolicy Bypass -File sync-vault.ps1
```

### macOS/Linux: Permission Issues
```bash
# Make script executable
chmod +x sync-vault-coordinated.sh
chmod +x sync-vault.sh
```

### Missing Platform Scripts
The wrapper will show clear error messages if required scripts are missing:
```
[ERROR] No Windows sync scripts found!
[INFO] Please copy one of these to your vault root:
[INFO]   - sync-vault.ps1 (PowerShell - recommended)
[INFO]   - sync-vault.bat (Batch script)  
[INFO]   - sync-vault-wsl.bat (WSL wrapper)
```

## Testing
Test the wrapper manually before using with the plugin:
```bash
# Navigate to your vault root
cd /path/to/your-vault

# Run the wrapper
./sync-vault-coordinated.sh
```

## Benefits
- **No Manual Configuration**: Works automatically across all platforms
- **Future-Proof**: Add new platforms by extending the detection logic
- **Plugin Compatible**: Integrates seamlessly with Obsidian sync plugins
- **Maintainable**: Single wrapper, platform-specific scripts remain separate
- **Debugging Friendly**: Clear error messages and status reporting
