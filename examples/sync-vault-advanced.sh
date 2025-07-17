#!/bin/bash

# Advanced Vault Sync Script
# Enhanced version with better error handling and flexibility
# Place this file in your vault root directory and make it executable

set -e

# Change to script directory to ensure we're in the right location
cd "$(dirname "$0")"

echo "Starting advanced vault sync..."

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: Not a git repository. Please initialize git first."
    exit 1
fi

# Check if there are any changes
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit"
    exit 0
fi

# Add all changes to git
git add .

# Commit with the provided message (or default message)
COMMIT_MSG="${1:-"Auto-sync $(date +'%Y-%m-%d %H:%M:%S')"}"
if git commit -m "$COMMIT_MSG"; then
    echo "Changes committed successfully"
else
    echo "No changes to commit"
    exit 0
fi

# Push to remote with error handling
if git push origin main; then
    echo "Advanced sync completed successfully!"
else
    echo "Error: Failed to push to remote. Please check your connection and try again."
    exit 1
fi
