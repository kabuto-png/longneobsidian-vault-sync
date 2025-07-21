@echo off
:: Longneobsidian Vault Sync - Advanced Windows Version
:: Enhanced Git operations with error handling and flexibility

setlocal enabledelayedexpansion

:: Color setup for Windows
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "NC=[0m"

:: Configuration
set RETRY_COUNT=3
set RETRY_DELAY=2

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

echo %BLUE%[INFO]%NC% Advanced sync starting...

:: Check if in Git repository
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Not in a Git repository!
    exit /b 1
)

:: Check Git status
echo %BLUE%[INFO]%NC% Checking repository status...
git status --porcelain >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%[WARNING]%NC% Repository status check failed
)

:: Function: Retry operation
:retry_pull
set /a PULL_RETRY=0
:pull_loop
echo %BLUE%[INFO]%NC% Pulling latest changes... (attempt !PULL_RETRY!)
git pull origin main --no-rebase
if not errorlevel 1 goto :pull_success
set /a PULL_RETRY+=1
if !PULL_RETRY! lss %RETRY_COUNT% (
    echo %YELLOW%[WARNING]%NC% Pull failed, retrying in %RETRY_DELAY% seconds...
    timeout /t %RETRY_DELAY% /nobreak >nul
    goto :pull_loop
)
echo %RED%[ERROR]%NC% Failed to pull after %RETRY_COUNT% attempts
exit /b 1

:pull_success
echo %GREEN%[SUCCESS]%NC% Successfully pulled latest changes

:: Check for conflicts
git diff --name-only --diff-filter=U >nul 2>&1
if not errorlevel 1 (
    echo %RED%[ERROR]%NC% Merge conflicts detected! Please resolve manually.
    exit /b 1
)

:: Add all changes
echo %BLUE%[INFO]%NC% Adding changes...
git add -A

:: Check if there are changes to commit
git diff --cached --quiet
if not errorlevel 1 (
    echo %GREEN%[SUCCESS]%NC% No changes to commit
    goto :end
)

:: Show what will be committed
echo %BLUE%[INFO]%NC% Changes to be committed:
git diff --cached --name-status

:: Commit changes with retry
:retry_commit
set /a COMMIT_RETRY=0
:commit_loop
echo %BLUE%[INFO]%NC% Committing changes... (attempt !COMMIT_RETRY!)
git commit -m "%COMMIT_MESSAGE%"
if not errorlevel 1 goto :commit_success
set /a COMMIT_RETRY+=1
if !COMMIT_RETRY! lss %RETRY_COUNT% (
    echo %YELLOW%[WARNING]%NC% Commit failed, retrying in %RETRY_DELAY% seconds...
    timeout /t %RETRY_DELAY% /nobreak >nul
    goto :commit_loop
)
echo %RED%[ERROR]%NC% Failed to commit after %RETRY_COUNT% attempts
exit /b 1

:commit_success
echo %GREEN%[SUCCESS]%NC% Changes committed successfully

:: Push to remote with retry
:retry_push
set /a PUSH_RETRY=0
:push_loop
echo %BLUE%[INFO]%NC% Pushing to remote... (attempt !PUSH_RETRY!)
git push origin main
if not errorlevel 1 goto :push_success
set /a PUSH_RETRY+=1
if !PUSH_RETRY! lss %RETRY_COUNT% (
    echo %YELLOW%[WARNING]%NC% Push failed, retrying in %RETRY_DELAY% seconds...
    timeout /t %RETRY_DELAY% /nobreak >nul
    goto :push_loop
)
echo %RED%[ERROR]%NC% Failed to push after %RETRY_COUNT% attempts
exit /b 1

:push_success
echo %GREEN%[SUCCESS]%NC% Changes pushed successfully

:end
echo %GREEN%[SUCCESS]%NC% Advanced sync completed!

endlocal
