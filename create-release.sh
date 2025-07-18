#!/bin/bash

# Release Package Creator for Vault Sync Plugin
# Creates a ready-to-install package for Obsidian users

echo "🚀 Creating Vault Sync Plugin Release Package..."
echo "================================================"

# Create release directory structure
mkdir -p release/vault-sync
mkdir -p release/scripts/windows
mkdir -p release/scripts/unix

# Copy essential plugin files
echo "📦 Copying plugin files..."
cp main.js release/vault-sync/
cp manifest.json release/vault-sync/
cp styles.css release/vault-sync/ 2>/dev/null || echo "⚠️  No styles.css found (optional)"

# Copy sync scripts
echo "📁 Copying sync scripts..."
cp examples/sync-vault.sh release/scripts/unix/
cp examples/sync-vault-optimized.sh release/scripts/unix/
cp windows/sync-vault.bat release/scripts/windows/
cp windows/sync-vault.ps1 release/scripts/windows/

# Copy documentation
echo "📄 Copying documentation..."
cp README.md release/
cp INSTALLATION.md release/
cp windows/README.md release/WINDOWS-GUIDE.md

# Create installation script for Windows
cat > release/INSTALL-WINDOWS.bat << 'EOF'
@echo off
echo ============================================
echo   Vault Sync Plugin - Windows Installer
echo ============================================
echo.

set /p "VAULT_PATH=Enter your Obsidian vault path: "
if "%VAULT_PATH%"=="" (
    echo Error: Vault path cannot be empty
    pause
    exit /b 1
)

if not exist "%VAULT_PATH%" (
    echo Error: Vault path does not exist
    pause
    exit /b 1
)

echo.
echo Creating plugin directory...
mkdir "%VAULT_PATH%\.obsidian\plugins\vault-sync" 2>nul

echo Copying plugin files...
copy "vault-sync\main.js" "%VAULT_PATH%\.obsidian\plugins\vault-sync\"
copy "vault-sync\manifest.json" "%VAULT_PATH%\.obsidian\plugins\vault-sync\"
copy "vault-sync\styles.css" "%VAULT_PATH%\.obsidian\plugins\vault-sync\" 2>nul

echo Copying sync script...
copy "scripts\windows\sync-vault.bat" "%VAULT_PATH%\"

echo.
echo ============================================
echo Installation completed successfully!
echo ============================================
echo.
echo Next steps:
echo 1. Open Obsidian
echo 2. Go to Settings -^> Community plugins
echo 3. Enable "Vault Sync"
echo 4. Configure the plugin settings
echo.
pause
EOF

# Create installation script for Unix/macOS
cat > release/install-unix.sh << 'EOF'
#!/bin/bash

echo "============================================"
echo "   Vault Sync Plugin - Unix/macOS Installer"
echo "============================================"
echo

read -p "Enter your Obsidian vault path: " VAULT_PATH
if [ -z "$VAULT_PATH" ]; then
    echo "Error: Vault path cannot be empty"
    exit 1
fi

if [ ! -d "$VAULT_PATH" ]; then
    echo "Error: Vault path does not exist"
    exit 1
fi

echo
echo "Creating plugin directory..."
mkdir -p "$VAULT_PATH/.obsidian/plugins/vault-sync"

echo "Copying plugin files..."
cp vault-sync/main.js "$VAULT_PATH/.obsidian/plugins/vault-sync/"
cp vault-sync/manifest.json "$VAULT_PATH/.obsidian/plugins/vault-sync/"
cp vault-sync/styles.css "$VAULT_PATH/.obsidian/plugins/vault-sync/" 2>/dev/null || true

echo "Copying sync script..."
cp scripts/unix/sync-vault-optimized.sh "$VAULT_PATH/"
chmod +x "$VAULT_PATH/sync-vault-optimized.sh"

echo
echo "============================================"
echo "Installation completed successfully!"
echo "============================================"
echo
echo "Next steps:"
echo "1. Open Obsidian"
echo "2. Go to Settings -> Community plugins"
echo "3. Enable 'Vault Sync'"
echo "4. Configure the plugin settings"
echo
EOF

chmod +x release/install-unix.sh

# Create README for release
cat > release/README-INSTALL.md << 'EOF'
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
EOF

# Create ZIP package
echo "🗜️  Creating ZIP package..."
cd release
zip -r vault-sync-plugin.zip . -x "*.DS_Store" "*.git*"
cd ..

echo "✅ Release package created: release/vault-sync-plugin.zip"
echo "📁 Installation files available in: release/"
echo "🎉 Ready for distribution!"

# Show package contents
echo ""
echo "📦 Package contents:"
unzip -l release/vault-sync-plugin.zip