# Windows Support for Obsidian Vault Sync

This directory contains Windows-compatible versions of the vault sync scripts for users without WSL.

## Available Scripts

### 1. `sync-vault.bat` - Windows Batch Script ⭐ **Recommended**
- **Best for**: Most Windows users
- **Requirements**: Only Git for Windows
- **Usage**: Double-click or run from command prompt
- **Features**:
  - Simple and reliable
  - Error handling with pause on errors
  - Auto-generated timestamps
  - Support for custom commit messages
  - Works on all Windows versions

### 2. `sync-vault.ps1` - PowerShell Script
- **Best for**: Users comfortable with PowerShell
- **Requirements**: PowerShell (built-in on Windows 10+)
- **Usage**: Right-click → "Run with PowerShell"
- **Features**:
  - Better error handling and colored output
  - Parameter support
  - More detailed error messages
  - Professional logging

## Installation

### Step 1: Install Git for Windows
1. Download from https://git-scm.com/download/win
2. Install with default options
3. Restart command prompt/PowerShell

### Step 2: Choose Your Script
**For most users** → Use `sync-vault.bat`
**For advanced users** → Use `sync-vault.ps1`

### Step 3: Copy Script to Vault
1. Copy your chosen script to your vault root directory
2. Make sure it's in the same folder as your `.obsidian` folder

### Step 4: Configure Obsidian Plugin
**For Batch Script:**
```
Command: sync-vault.bat
Arguments: (leave empty or add custom commit message)
```

**For PowerShell Script:**
```
Command: powershell.exe
Arguments: -ExecutionPolicy Bypass -File sync-vault.ps1
```

## Usage Examples

### Batch Script
```batch
:: Run with default message
sync-vault.bat

:: Run with custom message
sync-vault.bat "Updated my notes"
```

### PowerShell Script
```powershell
# Run with default message
.\sync-vault.ps1

# Run with custom message
.\sync-vault.ps1 -CommitMessage "Updated my notes"
```

## Troubleshooting

### Common Issues:

1. **"Git is not recognized as an internal or external command"**
   - Download and install Git for Windows from https://git-scm.com/
   - Restart command prompt after installation
   - Check if Git is in PATH: `git --version`

2. **"Execution policy error" (PowerShell only)**
   - Run PowerShell as Administrator
   - Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
   - Or use the batch script instead

3. **"Access denied" errors**
   - Ensure you have write permissions in the vault directory
   - Try running as administrator
   - Check if files are not read-only

4. **Sync fails with "nothing to commit"**
   - This is normal when no changes were made
   - The script will show "Warning: Nothing to commit"
   - Not an error, just informational

### Testing Your Setup

1. **Test Git installation:**
   ```cmd
   git --version
   ```

2. **Test in your vault directory:**
   ```cmd
   cd C:\path\to\your\vault
   git status
   ```

3. **Test the sync script:**
   ```cmd
   sync-vault.bat "Test commit"
   ```

## Why No WSL Version?

This directory focuses on **native Windows solutions** that work without additional setup:
- **Easier installation** - Just install Git for Windows
- **Better compatibility** - Works on all Windows versions
- **No extra dependencies** - No need for WSL or Linux subsystem
- **Simpler troubleshooting** - Native Windows tools

## Contributing

When contributing Windows scripts:
1. Test on Windows 10 and 11
2. Use native Windows commands only
3. Include proper error handling
4. Add clear documentation
5. Consider different user skill levels

---

💡 **Tip**: Start with the batch script (`sync-vault.bat`) - it's the simplest and most reliable option for most users!