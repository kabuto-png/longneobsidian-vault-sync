#!/bin/bash

# Coordinated Vault Sync Script with iCloud Support
# Optimized for mobile-desktop synchronization
# Place this file in your vault root directory and make it executable

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ICLOUD_ACTIVITY_THRESHOLD=60  # seconds
DEVICE_SWITCH_DELAY=2         # seconds (plugin-optimized)
MAX_WAIT_TIME=10              # seconds maximum wait

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Change to script directory
cd "$SCRIPT_DIR"

echo -e "${BLUE}🔄 Starting coordinated vault sync with iCloud support...${NC}"

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo -e "${RED}❌ Error: Not a git repository. Please initialize git first.${NC}"
    exit 1
fi

# Check if remote exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo -e "${RED}❌ Error: No remote origin configured. Please add a remote repository.${NC}"
    exit 1
fi

# Function to check iCloud activity
check_icloud_activity() {
    echo -e "${YELLOW}🔍 Checking for recent iCloud activity...${NC}"
    
    # Look for recent file changes (last 60 seconds)
    local recent_files=$(find . -name "*.md" -newermt "-${ICLOUD_ACTIVITY_THRESHOLD} seconds" 2>/dev/null | head -5)
    
    if [ -n "$recent_files" ]; then
        echo -e "${YELLOW}⚠️  Recent iCloud activity detected. Waiting ${DEVICE_SWITCH_DELAY}s for synchronization...${NC}"
        sleep $DEVICE_SWITCH_DELAY
        return 0
    else
        echo -e "${GREEN}✅ No recent iCloud activity detected${NC}"
        return 1
    fi
}

# Function to handle device coordination
coordinate_device_switch() {
    local device_file=".last_sync_device"
    local current_device=$(hostname)
    
    if [ -f "$device_file" ]; then
        local last_device=$(cat "$device_file")
        if [ "$last_device" != "$current_device" ]; then
            echo -e "${YELLOW}🔄 Device switch detected: $last_device → $current_device${NC}"
            echo -e "${YELLOW}⏳ Coordinating device switch (${DEVICE_SWITCH_DELAY}s)...${NC}"
            sleep $DEVICE_SWITCH_DELAY
        fi
    fi
    
    # Update device tracking
    echo "$current_device" > "$device_file"
}

# Function to wait for iCloud to settle
wait_for_icloud_settle() {
    local wait_time=0
    local max_wait=$MAX_WAIT_TIME
    
    echo -e "${YELLOW}⏳ Waiting for iCloud to settle...${NC}"
    
    while [ $wait_time -lt $max_wait ]; do
        # Check if there are any .tmp files or recent modifications
        local tmp_files=$(find . -name "*.tmp" -o -name ".*tmp*" 2>/dev/null | head -1)
        local recent_mods=$(find . -name "*.md" -newermt "-5 seconds" 2>/dev/null | head -1)
        
        if [ -z "$tmp_files" ] && [ -z "$recent_mods" ]; then
            echo -e "${GREEN}✅ iCloud appears settled${NC}"
            return 0
        fi
        
        echo -e "${YELLOW}⏳ iCloud activity detected, waiting... (${wait_time}s/${max_wait}s)${NC}"
        sleep 1
        wait_time=$((wait_time + 1))
    done
    
    echo -e "${YELLOW}⚠️  Proceeding after maximum wait time${NC}"
    return 0
}

# Main coordination process
echo -e "${BLUE}🔄 Starting iCloud coordination...${NC}"

# Check for recent iCloud activity
if check_icloud_activity; then
    # If activity detected, wait for settling
    wait_for_icloud_settle
fi

# Handle device coordination
coordinate_device_switch

# Pull latest changes from remote
echo -e "${BLUE}📥 Pulling latest changes from remote...${NC}"
if git pull origin main --rebase; then
    echo -e "${GREEN}✅ Successfully pulled from remote${NC}"
else
    echo -e "${RED}❌ Failed to pull from remote. Please resolve conflicts manually.${NC}"
    exit 1
fi

# Check if there are any changes after pull
if git diff --quiet && git diff --cached --quiet; then
    echo -e "${GREEN}ℹ️  No changes to commit after pull${NC}"
    exit 0
fi

# Add all changes to git
echo -e "${BLUE}📦 Adding changes to git...${NC}"
git add .

# Commit with the provided message (or default message)
COMMIT_MSG="${1:-"Coordinated sync with iCloud - $(date +'%Y-%m-%d %H:%M:%S')"}"
if git commit -m "$COMMIT_MSG"; then
    echo -e "${GREEN}✅ Changes committed successfully${NC}"
else
    echo -e "${GREEN}ℹ️  No changes to commit${NC}"
    exit 0
fi

# Push to remote with retry logic
echo -e "${BLUE}📤 Pushing changes to remote...${NC}"
MAX_RETRIES=2
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if git push origin main; then
        echo -e "${GREEN}🎉 Coordinated sync completed successfully!${NC}"
        echo -e "${GREEN}📱 Ready for device switch${NC}"
        exit 0
    else
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo -e "${YELLOW}🔄 Push failed, retrying... (attempt $RETRY_COUNT/$MAX_RETRIES)${NC}"
            sleep 2
            # Pull again in case of new changes
            git pull origin main --rebase
        else
            echo -e "${RED}❌ Failed to push after $MAX_RETRIES attempts. Please check connection.${NC}"
            exit 1
        fi
    fi
done
