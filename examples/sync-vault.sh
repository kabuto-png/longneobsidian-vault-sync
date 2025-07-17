#!/bin/bash

# Basic Vault Sync Script
# This is the simplest sync script for Obsidian Vault Sync plugin
# Place this file in your vault root directory and make it executable

set -e

echo "Starting basic vault sync..."

# Add all changes to git
git add .

# Commit with the provided message (or default message)
COMMIT_MSG="${1:-"Auto-sync $(date +'%Y-%m-%d %H:%M:%S')"}"
git commit -m "$COMMIT_MSG"

# Push to remote
git push origin main

echo "Basic sync completed successfully!"
