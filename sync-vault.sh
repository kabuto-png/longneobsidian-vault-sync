#!/bin/bash
# Basic Obsidian Vault Sync Script
# Cross-platform Git synchronization for Obsidian vaults

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    print_error "Not in a Git repository. Please initialize Git first."
    print_info "Run: git init && git remote add origin <your-repo-url>"
    exit 1
fi

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    print_info "Detected changes in vault. Committing..."
    
    # Add all changes
    git add .
    
    # Create commit message with timestamp
    commit_msg="Vault sync: $(date '+%Y-%m-%d %H:%M:%S')"
    
    if git commit -m "$commit_msg"; then
        print_success "Changes committed: $commit_msg"
    else
        print_error "Failed to commit changes"
        exit 1
    fi
else
    print_info "No changes detected in vault"
fi

# Pull changes from remote
print_info "Pulling changes from remote..."
if git pull --rebase; then
    print_success "Successfully pulled changes"
else
    print_warning "Pull had conflicts or issues. You may need to resolve manually."
fi

# Push changes to remote
print_info "Pushing changes to remote..."
if git push; then
    print_success "Successfully pushed changes to remote"
    print_success "Vault sync complete! ✨"
else
    print_error "Failed to push changes"
    print_info "You may need to run: git push --set-upstream origin main"
    exit 1
fi

print_info "Sync operation finished"
