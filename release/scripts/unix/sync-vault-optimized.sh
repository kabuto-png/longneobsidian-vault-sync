#!/bin/bash

# Optimized Vault Sync Script
# Full-featured version with conflict resolution and comprehensive error handling
# Place this file in your vault root directory and make it executable

set -e

# Change to script directory to ensure we're in the right location
cd "$(dirname "$0")"

echo "Starting optimized vault sync..."

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: Not a git repository. Please initialize git first."
    exit 1
fi

# Check if remote exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Error: No remote origin configured. Please add a remote repository."
    exit 1
fi

# Pull latest changes from remote to avoid conflicts
echo "Pulling latest changes from remote..."
if ! git pull origin main --rebase; then
    echo "Error: Failed to pull from remote. Please resolve conflicts manually."
    exit 1
fi

# Check if there are any changes after pull
if git diff --quiet && git diff --cached --quiet; then
    echo "No changes to commit after pull"
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

# Push to remote with retry logic
echo "Pushing changes to remote..."
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if git push origin main; then
        echo "Optimized sync completed successfully!"
        exit 0
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo "Push failed, retrying in 5 seconds... (attempt $RETRY_COUNT/$MAX_RETRIES)"
            sleep 5
            # Pull again in case of new changes
            git pull origin main --rebase
        else
            echo "Error: Failed to push after $MAX_RETRIES attempts. Please check your connection and try again."
            exit 1
        fi
    fi
done
