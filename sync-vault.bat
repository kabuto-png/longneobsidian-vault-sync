@echo off
:: Longneobsidian Vault Sync - Basic Windows Version
:: Simple Git operations for Windows

setlocal

:: Get timestamp for commit message
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

echo [INFO] Basic sync starting...

:: Check if in Git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Not in a Git repository!
    exit /b 1
)

:: Pull latest changes
echo [INFO] Pulling latest changes...
git pull origin main --no-rebase
if errorlevel 1 (
    echo [ERROR] Failed to pull latest changes
    exit /b 1
)

:: Add all changes
echo [INFO] Adding changes...
git add -A

:: Check if there are changes to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo [SUCCESS] No changes to commit
    goto :end
)

:: Commit changes
echo [INFO] Committing changes...
git commit -m "%COMMIT_MESSAGE%"
if errorlevel 1 (
    echo [ERROR] Failed to commit changes
    exit /b 1
)

:: Push to remote
echo [INFO] Pushing to remote...
git push origin main
if errorlevel 1 (
    echo [ERROR] Failed to push to remote
    exit /b 1
)

:end
echo [SUCCESS] Basic sync completed!

endlocal
