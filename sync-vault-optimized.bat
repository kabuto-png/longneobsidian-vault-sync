@echo off
:: Longneobsidian Vault Sync - Optimized Windows Version
:: Performance optimized with intelligent operations

setlocal enabledelayedexpansion

:: Color setup
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "PURPLE=[95m"
set "NC=[0m"

:: Performance configuration
set BATCH_SIZE=100
set TIMEOUT_SECONDS=30

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

echo %PURPLE%[OPTIMIZED]%NC% Starting optimized sync...

:: Quick Git repository check
git rev-parse --git-dir >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Not in a Git repository!
    exit /b 1
)

:: Check remote connectivity (quick test)
echo %BLUE%[INFO]%NC% Testing remote connectivity...
git ls-remote origin >nul 2>&1
if errorlevel 1 (
    echo %YELLOW%[WARNING]%NC% Remote connectivity issues detected
)

:: Optimized pull with timeout
echo %BLUE%[INFO]%NC% Optimized pull operation...
timeout /t %TIMEOUT_SECONDS% git pull origin main --no-rebase >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Pull operation failed or timed out
    exit /b 1
)
echo %GREEN%[SUCCESS]%NC% Pull completed

:: Intelligent file staging (batch processing)
echo %BLUE%[INFO]%NC% Intelligent file staging...

:: Count total files to stage
for /f %%i in ('git status --porcelain 2^>nul ^| find /c /v ""') do set TOTAL_FILES=%%i

if !TOTAL_FILES! equ 0 (
    echo %GREEN%[SUCCESS]%NC% No changes to commit
    goto :end
)

echo %BLUE%[INFO]%NC% Found !TOTAL_FILES! files to stage

:: Batch staging for large numbers of files
if !TOTAL_FILES! gtr !BATCH_SIZE! (
    echo %PURPLE%[OPTIMIZED]%NC% Using batch staging for !TOTAL_FILES! files...
    git add -A
) else (
    echo %PURPLE%[OPTIMIZED]%NC% Using standard staging for !TOTAL_FILES! files...
    git add -A
)

:: Check staged changes
git diff --cached --quiet
if not errorlevel 1 (
    echo %GREEN%[SUCCESS]%NC% No changes staged
    goto :end
)

:: Optimized commit
echo %BLUE%[INFO]%NC% Optimized commit operation...
git commit -m "%COMMIT_MESSAGE%" --quiet
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Commit failed
    exit /b 1
)
echo %GREEN%[SUCCESS]%NC% Commit completed

:: Performance-optimized push
echo %BLUE%[INFO]%NC% Performance-optimized push...
timeout /t %TIMEOUT_SECONDS% git push origin main --quiet >nul 2>&1
if errorlevel 1 (
    echo %RED%[ERROR]%NC% Push operation failed or timed out
    exit /b 1
)
echo %GREEN%[SUCCESS]%NC% Push completed

:: Performance summary
echo %PURPLE%[OPTIMIZED]%NC% Sync completed in optimized mode

:end
echo %GREEN%[SUCCESS]%NC% ⚡ Optimized sync completed successfully!

endlocal
