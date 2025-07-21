# Basic Obsidian Vault Sync Script (PowerShell)
# Cross-platform Git synchronization for Obsidian vaults

param(
    [string]$CommitMessage = "Vault sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
)

# Color functions for output
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Blue }
function Write-Success { param($msg) Write-Host "[SUCCESS] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[WARNING] $msg" -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Check if we're in a git repository
if (-not (Test-Path ".git")) {
    Write-Error "Not in a Git repository. Please initialize Git first."
    Write-Info "Run: git init && git remote add origin <your-repo-url>"
    exit 1
}

# Check for uncommitted changes
$status = git status --porcelain
if ($status) {
    Write-Info "Detected changes in vault. Committing..."
    
    # Add all changes
    git add .
    
    # Create commit
    if (git commit -m $CommitMessage) {
        Write-Success "Changes committed: $CommitMessage"
    } else {
        Write-Error "Failed to commit changes"
        exit 1
    }
} else {
    Write-Info "No changes detected in vault"
}

# Pull changes from remote
Write-Info "Pulling changes from remote..."
if (git pull --rebase) {
    Write-Success "Successfully pulled changes"
} else {
    Write-Warning "Pull had conflicts or issues. You may need to resolve manually."
}

# Push changes to remote
Write-Info "Pushing changes to remote..."
if (git push) {
    Write-Success "Successfully pushed changes to remote"
    Write-Success "Vault sync complete! ✨"
} else {
    Write-Error "Failed to push changes"
    Write-Info "You may need to run: git push --set-upstream origin main"
    exit 1
}

Write-Info "Sync operation finished"
