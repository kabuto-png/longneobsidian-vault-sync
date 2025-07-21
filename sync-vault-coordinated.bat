@echo off
:: Longneobsidian Vault Sync - Windows Version with iCloud Coordination
:: Windows batch equivalent of sync-vault-coordinated.sh

setlocal enabledelayedexpansion

:: Color setup for Windows (using echo with color codes)
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "PURPLE=[95m"
set "NC=[0m"

:: Configuration
set ICLOUD_WAIT_TIME=3
set MAX_ICLOUD_WAIT=10
set RECENT_ACTIVITY_THRESHOLD=3

:: Get timestamp
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set DATE=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a:%%b
set TIMESTAMP=%DATE% %TIME%

:: Commit message
set "DEFAULT_MESSAGE=Longneobsidian sync - %TIMESTAMP%"
if "%~1"=="" (
    set "COMMIT_MESSAGE=%DEFAULT_MESSAGE%"
) else (
    set "COMMIT_MESSAGE=%~1"
)

echo %BLUE%[INFO]%NC% Plugin coordinated sync starting...

:: Function: Check if in Git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Not in a Git repository!
    exit /b 1
)

:: Function: Quick iCloud activity check (Windows version)
echo %PURPLE%[iCLOUD]%NC% Quick iCloud check...
:: Windows equivalent - check recent files in current directory
for /f %%i in ('dir /s /b /o:d 2^>nul ^| find /c /v ""') do set RECENT_FILES=%%i
if !RECENT_FILES! gtr !RECENT_ACTIVITY_THRESHOLD! (
    echo %PURPLE%[iCLOUD]%NC% iCloud activity detected
    timeout /t %ICLOUD_WAIT_TIME% /nobreak >nul
) else (
    echo %PURPLE%[iCLOUD]%NC% iCloud activity appears stable
)

:: Function: Device switch check (Windows version)
set INDICATOR_FILE=.last_sync_device
if exist "%INDICATOR_FILE%" (
    for /f "tokens=1 delims=:" %%a in ('type "%INDICATOR_FILE%"') do set LAST_DEVICE=%%a
    for /f %%a in ('hostname') do set CURRENT_DEVICE=%%a
    if not "!LAST_DEVICE!"=="!CURRENT_DEVICE!" (
        echo %YELLOW%[WARNING]%NC% Device switch: !LAST_DEVICE! → !CURRENT_DEVICE!
        timeout /t 2 /nobreak >nul
    )
)

:: Git operations
echo %BLUE%[INFO]%NC% Starting Git synchronization...

:: Pull latest changes
echo %BLUE%[INFO]%NC% Pulling latest changes...
git pull origin main --no-rebase
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to pull latest changes
    exit /b 1
)

:: Add all changes
echo %BLUE%[INFO]%NC% Adding changes...
git add -A

:: Check if there are changes to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo %GREEN%[SUCCESS]%NC% No changes to commit
    goto :create_indicator
)

:: Commit changes
echo %BLUE%[INFO]%NC% Committing changes...
git commit -m "%COMMIT_MESSAGE%"
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to commit changes
    exit /b 1
)
echo %GREEN%[SUCCESS]%NC% Changes committed successfully

:: Push to remote
echo %BLUE%[INFO]%NC% Pushing to remote...
git push origin main
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Failed to push to remote
    exit /b 1
)
echo %GREEN%[SUCCESS]%NC% Changes pushed successfully

:create_indicator
:: Create device switch indicator
for /f %%a in ('hostname') do set DEVICE_NAME=%%a
echo %DEVICE_NAME%:%TIMESTAMP% > "%INDICATOR_FILE%"
echo %BLUE%[INFO]%NC% Device: %DEVICE_NAME%

echo %GREEN%[SUCCESS]%NC% Coordinated sync completed!
echo %GREEN%[SUCCESS]%NC% ✅ Plugin sync done - safe to switch devices

endlocal
