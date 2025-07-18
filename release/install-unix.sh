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
