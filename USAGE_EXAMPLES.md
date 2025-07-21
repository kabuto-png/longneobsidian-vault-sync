# Example Usage

## Quick Start

### Step 1: Navigate to your vault
```bash
# Example vault locations:
cd "~/Documents/My Vault"
# or
cd "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/My Vault"
# or  
cd "C:\Users\YourName\Documents\My Vault"  # Windows
```

### Step 2: Run one-line installer
```bash
bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)
```

### Step 3: Configure Obsidian plugin
1. Open Obsidian → Settings → Community Plugins
2. Install "Obsidian Git" plugin (or similar)
3. Configure plugin:
   - **Sync Script**: `sync-vault-coordinated.sh`
   - **Auto-sync**: Enable (optional)

## What You'll See

### During Installation:
```
╔════════════════════════════════════════════════════════════╗
║              Obsidian Vault Sync Installer                ║
║            Universal Cross-Platform Setup                 ║
╚════════════════════════════════════════════════════════════╝

[INFO] Detecting Obsidian vault directory...
[SUCCESS] Found vault directory: /Users/you/Documents/My Vault
[INFO] macOS environment detected
[INFO] Downloading sync scripts...
[SUCCESS] Downloaded universal wrapper
[SUCCESS] Downloaded bash script
[SUCCESS] Installation completed successfully!
```

### During Sync:
```
[INFO] Starting Obsidian Vault Sync...
[INFO] Detecting operating system...
[INFO] macOS environment detected
[INFO] Using bash script for macOS
[SUCCESS] Vault sync completed successfully!
```

## Platform Examples

### Windows User
```powershell
# Navigate to vault
cd "C:\Users\John\Documents\Obsidian\My Vault"

# Install (PowerShell or Command Prompt)
bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)

# What gets installed:
# ✓ sync-vault-coordinated.sh (universal wrapper)
# ✓ sync-vault.ps1 (PowerShell - primary)
# ✓ sync-vault.bat (Batch - backup)
# ✓ sync-vault-wsl.bat (WSL - if available)
```

### macOS User  
```bash
# Navigate to vault
cd "~/Documents/Obsidian/My Vault"

# Install
bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)

# What gets installed:
# ✓ sync-vault-coordinated.sh (universal wrapper)
# ✓ sync-vault.sh (bash script)
```

### Linux User
```bash
# Navigate to vault
cd "~/Documents/Obsidian/My Vault"

# Install
bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)

# What gets installed:
# ✓ sync-vault-coordinated.sh (universal wrapper)  
# ✓ sync-vault.sh (bash script)
```

## Testing Your Setup

### Manual Test
```bash
# Test the universal wrapper
./sync-vault-coordinated.sh

# Should show:
# [INFO] Starting Obsidian Vault Sync...
# [INFO] Detecting operating system...
# [INFO] [Your OS] environment detected
# [SUCCESS] Vault sync completed successfully!
```

### Plugin Test
1. Open Obsidian
2. Go to sync plugin settings
3. Should see `sync-vault-coordinated.sh` in script dropdown
4. Click "Sync Now" - should work without errors

## Common Vault Structures After Install

```
My Vault/
├── .obsidian/                    # Obsidian settings
├── .git/                         # Git repository  
├── .gitignore                    # ✓ Created by installer
├── sync-vault-coordinated.sh     # ✓ Universal wrapper
├── sync-vault.sh                 # ✓ Platform script (macOS/Linux)
├── sync-vault.ps1                # ✓ Platform script (Windows)
├── Daily Notes/                  # Your content
├── Templates/                    # Your content  
└── Projects/                     # Your content
```

## Customization

### Custom Git Commands
Edit the platform-specific scripts to customize sync behavior:
- **Windows**: Edit `sync-vault.ps1` or `sync-vault.bat`
- **macOS/Linux**: Edit `sync-vault.sh`

### Custom Sync Schedule
Configure in your Obsidian sync plugin:
- Auto-sync interval
- Sync on startup
- Sync on file change

### Multiple Vaults
Run the installer in each vault directory:
```bash
cd "~/Documents/Vault1" && bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)
cd "~/Documents/Vault2" && bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)
```

Each vault gets its own sync setup!
