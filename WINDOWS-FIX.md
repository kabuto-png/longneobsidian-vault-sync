# Windows Compatibility Fix

## Problem
Install script worked perfectly on Windows, but sync execution failed with:
```
'bash' is not recognized as an internal or external command
```

## Root Cause
- Plugin was hardcoded to use `bash` command for all script execution
- Windows doesn't have native `bash` - needed PowerShell or Batch scripts
- Plugin settings only offered `.sh` files regardless of OS

## Solution Implemented

### 1. Plugin Code Updates (`src/main.ts`)
- **OS Detection**: Added `process.platform === 'win32'` check
- **Smart Execution**: 
  - Windows: Uses PowerShell (`powershell -ExecutionPolicy Bypass -File script.ps1`)
  - Windows fallback: Batch files (`.bat`)
  - Unix/macOS: Uses bash as before
- **Dynamic Settings**: Settings dropdown now shows appropriate scripts per OS

### 2. New PowerShell Scripts
- **`sync-vault.ps1`**: Basic PowerShell sync script
- **`sync-vault-coordinated.ps1`**: Universal wrapper with fallback logic
- Both scripts have Windows-native color output and error handling

### 3. Install Script Enhancement
- Downloads PowerShell scripts for Windows users
- Tests appropriate script types per OS
- Maintains cross-platform compatibility

### 4. Execution Priority (Windows)
1. **PowerShell (.ps1)** - Primary, most reliable
2. **Batch (.bat)** - Fallback for restricted environments  
3. **WSL Bash (.sh)** - Last resort if WSL installed

## Testing Results
✅ Install script works on Windows  
✅ Plugin builds successfully  
✅ PowerShell scripts download correctly  
❌ Need to test actual sync execution on Windows

## Next Steps for User
1. Re-install plugin with new version:
   ```bash
   bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)
   ```

2. In Obsidian plugin settings, select:
   - **"Basic (PowerShell)"** for `sync-vault.ps1`
   - **"With iCloud (PowerShell)"** for `sync-vault-coordinated.ps1`

3. Test sync functionality within Obsidian

## Troubleshooting
If PowerShell execution is restricted:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Or use batch file fallback option in plugin settings.
