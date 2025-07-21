#!/bin/bash
# Basic macOS sync script for testing
# Replace this with your actual sync logic

echo "Starting vault sync on macOS..."

# Add your git sync commands here
git add .
git commit -m "Auto sync - $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo "Sync completed!"
