@echo off
REM Quick Windows sync test
echo [INFO] Testing Windows Vault Sync...

REM Check if PowerShell is available
where powershell >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] PowerShell detected
    if exist "sync-vault.ps1" (
        echo [INFO] Running PowerShell sync script...
        powershell -ExecutionPolicy Bypass -File "sync-vault.ps1" "Test sync from Windows"
    ) else (
        echo [ERROR] sync-vault.ps1 not found
    )
) else (
    echo [ERROR] PowerShell not available
    echo [INFO] Falling back to direct Git commands...
    git add .
    git commit -m "Test sync from Windows batch"
    git pull --rebase
    git push
)

echo [INFO] Windows sync test completed
pause
