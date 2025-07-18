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
