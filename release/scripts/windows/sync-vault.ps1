# Basic Vault Sync Script for Windows PowerShell
# This is the PowerShell version of the sync script for Obsidian Vault Sync plugin
# Place this file in your vault root directory

param(
    [string]$CommitMessage = ""
)

Write-Host "Starting basic vault sync..." -ForegroundColor Green

try {
    # Add all changes to git
    Write-Host "Adding files to git..." -ForegroundColor Yellow
    git add .
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to add files to git"
    }

    # Commit with the provided message (or default message)
    if ([string]::IsNullOrEmpty($CommitMessage)) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $CommitMessage = "Auto-sync $timestamp"
    }
    
    Write-Host "Committing with message: $CommitMessage" -ForegroundColor Yellow
    git commit -m $CommitMessage
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Nothing to commit or commit failed" -ForegroundColor Yellow
    }

    # Push to remote
    Write-Host "Pushing to remote..." -ForegroundColor Yellow
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to push to remote"
    }

    Write-Host "Basic sync completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Keep console open if running from explorer
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "Press any key to continue..." -ForegroundColor Cyan
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}