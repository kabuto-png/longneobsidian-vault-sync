# Vault Sync Plugin - Technical Documentation

> **Version**: 2.1.0  
> **Author**: kabuto-png  
> **Last Updated**: 2025-07-17

## 📋 Overview

The Vault Sync plugin is a comprehensive Obsidian plugin for Git vault synchronization. It provides enhanced features including real-time status tracking, sync counting, and comprehensive auto-sync capabilities with a user-friendly interface.

## ✨ Key Features (v2.1.0)

### 📊 Enhanced Status Tracking
- **Real-time status bar** - Shows sync status at bottom of Obsidian
- **Last sync timestamp** - Human-readable format ("5m ago", "2h ago")
- **Total sync counter** - Persistent count of successful syncs
- **Sync duration tracking** - Performance timing for each operation
- **Clickable status bar** - Click for detailed status information

### 🔄 Advanced Auto-sync  
- **Configurable intervals** - 1-60 minutes between syncs
- **Visual status indicators** - Status bar shows current mode
- **One-click toggle** - Enable/disable via command palette
- **Persistent settings** - Survives Obsidian restarts
- **Background operation** - Non-intrusive automatic syncing

### 🎛️ Comprehensive Settings Panel
- **Multiple sync scripts** - Choose between basic/advanced/optimized
- **Notification control** - Enable/disable sync notifications  
- **Manual actions** - Sync now, view status, reset counter
- **Real-time preview** - See current status in settings

### 🕒 Smart Time Display
- **Relative timestamps** - "Just now", "5 minutes ago", "2 hours ago"
- **Sync performance** - Shows duration of each sync operation
- **Predictable scheduling** - Know when next auto-sync will occur

## 🚀 Installation & Setup

### Plugin Files
```
.obsidian/plugins/vault-sync/
├── main.js           # Main plugin code
├── manifest.json     # Plugin metadata v2.1.0
├── styles.css        # UI styling
└── README.md         # Basic plugin info
```

### Required Sync Scripts
The plugin requires one of these bash scripts in vault root:
- `sync-vault.sh` - Basic Git operations
- `sync-vault-advanced.sh` - Enhanced with location handling  
- `sync-vault-optimized.sh` - Full-featured ⭐ **Recommended**

### Enable Plugin
1. **Settings** → **Community plugins**
2. Find **"Vault Sync"**
3. **Toggle ON**
4. Configure in **plugin settings**

## 🎮 User Interface

### Status Bar (Bottom of Obsidian)
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

**Click status bar** for detailed information popup.

### Ribbon Icon (Left Sidebar)
- **Click** to trigger immediate manual sync
- **Tooltip**: "Vault Sync"
- **Visual feedback** during sync operations

### Command Palette (Ctrl+P)
Three commands available:
1. **`Sync Vault (Manual)`** - Immediate sync
2. **`Toggle Auto-Sync`** - Enable/disable auto-sync
3. **`View Sync Status`** - Detailed status modal

## ⚙️ Configuration

### Settings Panel
**Access**: Settings → Community plugins → Vault Sync

#### Current Status Display
Shows real-time information:
- Auto-sync status (Enabled/Disabled + interval)
- Last sync time  
- Total sync count
- Currently selected sync script

#### Sync Script Selection
Choose your preferred script:
- **Basic** (`sync-vault.sh`) - Simple Git operations
- **Advanced** (`sync-vault-advanced.sh`) - Location-flexible
- **Optimized** (`sync-vault-optimized.sh`) - Recommended
- **With iCloud** (`sync-vault-coordinated.sh`) - Mobile-desktop coordination

#### Auto-sync Configuration
- **Enable Auto-sync** - Toggle on/off
- **Auto-sync Interval** - Slider: 1-60 minutes
- **Show Notifications** - Display sync status messages

#### Manual Actions
- **🔄 Sync Now** - Trigger immediate sync
- **📊 View Status** - Detailed information modal  
- **🔄 Reset Counter** - Reset sync count to zero

## 🔄 Sync Behavior

### Manual Sync Process
1. **Trigger** - Click ribbon icon or use command
2. **Execution** - Runs selected bash script
3. **Timing** - Measures and displays duration
4. **Commit Message** - `"Vault sync - 2025-07-17 14:30"`
5. **Update Status** - Increments counter, updates timestamp
6. **Notification** - Shows result and duration

### Auto-sync Process
1. **Schedule** - Runs every X minutes (configurable)
2. **Background** - Non-intrusive operation
3. **Same Process** - Identical to manual sync
4. **Status Updates** - Real-time status bar updates
5. **Error Handling** - Notifications on failure

### Commit Message Format
```
Vault sync - [ISO timestamp]
```
**Example**: `Vault sync - 2025-07-17 14:30`

## 📊 Status Information

### Time Display Formats
- **"Just now"** - Less than 1 minute ago
- **"5m ago"** - 5 minutes since last sync
- **"2h ago"** - 2 hours since last sync
- **"3d ago"** - 3 days since last sync  
- **"Never"** - No sync performed yet

### Auto-sync Indicators
- **🔄 Auto: Xm** - Enabled with X minute intervals
- **⏸️ Manual** - Disabled, manual sync only

### Sync Counter
- **Persistent** - Saved across Obsidian restarts
- **Success Only** - Only counts successful syncs
- **Resettable** - Can be reset to zero in settings

## 🔧 Troubleshooting

### Plugin Issues

#### Plugin Won't Load
**Symptoms**: Missing from Community plugins or won't enable
**Solutions**:
1. **Restart Obsidian** completely
2. **Check plugin files** exist in `.obsidian/plugins/vault-sync/`
3. **Verify manifest.json** is valid JSON
4. **Re-enable** in Community plugins

#### Auto-sync Not Working
**Symptoms**: Shows "Manual" instead of "Auto" in status bar
**Solutions**:
1. **Check settings** - Ensure auto-sync is enabled
2. **Verify status bar** - Should show "🔄 Auto: Xm"
3. **Script permissions** - Ensure bash script is executable:
   ```bash
   chmod +x sync-vault-optimized.sh
   ```
4. **Toggle auto-sync** via command palette

#### Status Not Updating
**Symptoms**: Status bar shows old information
**Solutions**:
1. **Click status bar** to force refresh
2. **Restart plugin** - Disable and re-enable
3. **Check Git status** - Ensure repository is healthy
4. **Verify location** - Must be run from Git repository

### Sync Issues

#### Sync Failures
**Symptoms**: Error notifications during sync
**Solutions**:
1. **Check internet connection**
2. **Verify Git remote** accessibility
3. **Resolve merge conflicts** manually
4. **Check script permissions** and paths

#### No Notifications
**Symptoms**: Silent sync operations
**Solutions**:
1. **Enable in plugin settings** - "Show Notifications" ✓
2. **Check Obsidian notifications** - Settings → General
3. **Test manual sync** for immediate feedback

## 🔍 Technical Details

### Plugin Architecture
- **Main Class**: `VaultSyncPlugin`
- **Settings Class**: `VaultSyncSettingTab`
- **Storage**: Obsidian's data.json API
- **Git Integration**: Bash script execution via Node.js child_process

### Data Storage
**Location**: `.obsidian/plugins/vault-sync/data.json`

**Stored Settings**:
```json
{
    "syncScript": "sync-vault-optimized.sh",
    "autoSyncInterval": 5,
    "autoSyncEnabled": false, 
    "showNotifications": true,
    "syncOnStartup": false,
    "lastSyncTime": "2025-07-17T14:30:00.000Z",
    "syncCount": 47
}
```

### Performance
- **Memory**: Minimal - single timer when auto-sync enabled
- **CPU**: Low - only during sync operations  
- **Network**: Depends on vault size and changes
- **Storage**: Small settings file only

## 📈 Version History

### New in v2.1.0
- ✅ **Status bar** with real-time information
- ✅ **Sync counter** and timestamp tracking
- ✅ **Enhanced settings panel** with live status
- ✅ **Detailed status modal** via command palette
- ✅ **Performance timing** for each sync
- ✅ **Multiple sync script support**
- ✅ **Sync duration display** in notifications
- ✅ **Clickable status bar** for quick info
- ✅ **Reset counter functionality**

### Removed from v3.0.0 (Planned)
- ❌ Cross-platform Python support
- ❌ Conflict prevention system
- ❌ Multiple sync methods
- ❌ Advanced configuration options
- ❌ Built-in help system

## 🔧 Development

### TypeScript Structure
```
src/
├── main.ts           # Main plugin class
├── settings.ts       # Settings panel (future)
├── types.ts          # TypeScript interfaces (future)
└── utils.ts          # Utility functions (future)
```

### Build Process
```bash
# Install dependencies
npm install

# Development build (watch mode)
npm run dev

# Production build
npm run build

# Lint code
npm run lint

# Format code
npm run format
```

### Testing
```bash
# Run tests
npm test

# Test coverage
npm run test:coverage
```

## 📚 API Reference

### VaultSyncPlugin Class

#### Methods
- `syncVault(customMessage?: string)` - Trigger manual sync
- `toggleAutoSync()` - Enable/disable auto-sync
- `showSyncStatus()` - Display status modal
- `setupAutoSync()` - Initialize auto-sync timer
- `clearAutoSync()` - Clear auto-sync timer
- `updateStatusBar()` - Refresh status bar display

#### Properties
- `settings: VaultSyncSettings` - Plugin configuration
- `statusBarItemEl: HTMLElement` - Status bar element
- `lastSyncTime: string | null` - Last sync timestamp
- `syncCount: number` - Total sync counter

### VaultSyncSettings Interface
```typescript
interface VaultSyncSettings {
    syncScript: string;
    autoSyncInterval: number;
    autoSyncEnabled: boolean;
    showNotifications: boolean;
    syncOnStartup: boolean;
    lastSyncTime: string | null;
    syncCount: number;
}
```

---

**Documentation Version**: 2.1.0  
**Plugin Version**: 2.1.0  
**Last Updated**: 2025-07-17  
**Obsidian Compatibility**: 0.15.0+
