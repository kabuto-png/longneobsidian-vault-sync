@echo off
:: Simple Vault Sync Script for Windows
:: No WSL required - works with Git for Windows only
:: Place this file in your vault root directory

echo.
echo ================================================
echo         Obsidian Vault Sync for Windows
echo ================================================
echo.

:: Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Git is not installed or not in PATH
    echo.
    echo Please install Git for Windows from: https://git-scm.com/
    echo.
    pause
    exit /b 1
)

:: Check if we're in a git repository
if not exist ".git" (
    echo ❌ ERROR: This is not a Git repository
    echo.
    echo Please run 'git init' first or clone your vault from GitHub
    echo.
    pause
    exit /b 1
)

echo 🔄 Starting vault sync...
echo.

:: Add all changes to git
echo 📁 Adding files to git...
git add .
if %errorlevel% neq 0 (
    echo ❌ ERROR: Failed to add files to git
    echo.
    pause
    exit /b 1
)

:: Create commit message
set "COMMIT_MSG=%~1"
if "%COMMIT_MSG%"=="" (
    for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
    set "YYYY=%dt:~0,4%"
    set "MM=%dt:~4,2%"
    set "DD=%dt:~6,2%"
    set "HH=%dt:~8,2%"
    set "Min=%dt:~10,2%"
    set "SS=%dt:~12,2%"
    set "COMMIT_MSG=Auto-sync %YYYY%-%MM%-%DD% %HH%:%Min%:%SS%"
)

:: Commit changes
echo 💾 Committing changes: %COMMIT_MSG%
git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo ⚠️  WARNING: Nothing to commit (no changes detected)
    echo.
) else (
    echo ✅ Changes committed successfully
    echo.
)

:: Push to remote
echo 🚀 Pushing to remote repository...
git push origin main
if %errorlevel% neq 0 (
    echo ❌ ERROR: Failed to push to remote
    echo.
    echo Check your internet connection and repository permissions
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo ✅ Vault sync completed successfully!
echo ================================================
echo.
pause