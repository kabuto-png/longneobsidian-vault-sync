# Universal Obsidian Vault Sync Wrapper (PowerShell)
# Auto-detects OS and runs appropriate sync script

param(
    [string]$CommitMessage = "Vault sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

# Color functions
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Success { param($msg) Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

Write-Info "🔄 Universal Obsidian Vault Sync"
Write-Info "OS: Windows (PowerShell)"

# Check Git repository
if (-not (Test-Path ".git")) {
    Write-Error "Not in a Git repository. Please initialize Git first."
    exit 1
}

# Priority order for Windows:
# 1. PowerShell (.ps1)
# 2. Batch (.bat) 
# 3. WSL (.sh)

$scriptFound = $false

# Try PowerShell script first
if (Test-Path "sync-vault.ps1") {
    Write-Info "Found PowerShell script, executing..."
    try {
        & "./sync-vault.ps1" $CommitMessage
        $scriptFound = $true
    } catch {
        Write-Warning "PowerShell script failed: $_"
    }
}

# Try Batch script if PowerShell failed
if (-not $scriptFound -and (Test-Path "sync-vault.bat")) {
    Write-Info "Found Batch script, executing..."
    try {
        & "./sync-vault.bat" $CommitMessage
        $scriptFound = $true
    } catch {
        Write-Warning "Batch script failed: $_"
    }
}

# Try WSL Bash as last resort
if (-not $scriptFound -and (Test-Path "sync-vault.sh")) {
    Write-Info "Found Bash script, trying WSL..."
    try {
        if (Get-Command wsl -ErrorAction SilentlyContinue) {
            wsl bash sync-vault.sh $CommitMessage
            $scriptFound = $true
        } else {
            Write-Warning "WSL not available"
        }
    } catch {
        Write-Warning "WSL execution failed: $_"
    }
}

# Fallback: Direct Git commands
if (-not $scriptFound) {
    Write-Warning "No sync scripts found, using direct Git commands..."
    
    try {
        # Add all changes
        git add .
        
        # Commit if there are changes
        $status = git status --porcelain
        if ($status) {
            git commit -m $CommitMessage
            Write-Success "Changes committed"
        }
        
        # Pull and push
        git pull --rebase
        git push
        
        Write-Success "Fallback sync completed!"
    } catch {
        Write-Error "Fallback sync failed: $_"
        exit 1
    }
}

Write-Success "🎯 Sync operation completed successfully!"
