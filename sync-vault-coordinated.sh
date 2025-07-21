#!/bin/bash
# Universal Obsidian Vault Sync Wrapper
# Auto-detects OS and runs appropriate sync script
# Created for cross-platform compatibility

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if script exists
check_script_exists() {
    if [[ ! -f "$1" ]]; then
        print_error "Script not found: $1"
        print_info "Please ensure the script is in your vault root directory"
        return 1
    fi
    return 0
}

# Main execution
main() {
    print_info "Starting Obsidian Vault Sync..."
    print_info "Detecting operating system..."
    
    # Detect OS and run appropriate script
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OS" == "Windows_NT" ]]; then
        # Windows environment detected
        print_info "Windows environment detected"
        
        # Priority order: PowerShell -> Batch -> WSL
        if check_script_exists "sync-vault.ps1"; then
            print_info "Using PowerShell script (recommended for Windows)"
            powershell.exe -ExecutionPolicy Bypass -File "sync-vault.ps1"
            SYNC_EXIT_CODE=$?
        elif check_script_exists "sync-vault.bat"; then
            print_info "Using Windows Batch script"
            cmd.exe /c "sync-vault.bat"
            SYNC_EXIT_CODE=$?
        elif check_script_exists "sync-vault-wsl.bat"; then
            print_info "Using WSL wrapper script"
            cmd.exe /c "sync-vault-wsl.bat"
            SYNC_EXIT_CODE=$?
        else
            print_error "No Windows sync scripts found!"
            print_info "Please copy one of these to your vault root:"
            print_info "  - sync-vault.ps1 (PowerShell - recommended)"
            print_info "  - sync-vault.bat (Batch script)"
            print_info "  - sync-vault-wsl.bat (WSL wrapper)"
            exit 1
        fi
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS environment
        print_info "macOS environment detected"
        
        if check_script_exists "sync-vault.sh"; then
            print_info "Using bash script for macOS"
            bash "sync-vault.sh"
            SYNC_EXIT_CODE=$?
        else
            print_error "sync-vault.sh not found for macOS"
            print_info "Please ensure sync-vault.sh is in your vault root directory"
            exit 1
        fi
        
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux environment
        print_info "Linux environment detected"
        
        if check_script_exists "sync-vault.sh"; then
            print_info "Using bash script for Linux"
            bash "sync-vault.sh"
            SYNC_EXIT_CODE=$?
        else
            print_error "sync-vault.sh not found for Linux"
            print_info "Please ensure sync-vault.sh is in your vault root directory"
            exit 1
        fi
        
    else
        # Unknown OS
        print_warning "Unknown operating system: $OSTYPE"
        print_info "Attempting to use bash script as fallback"
        
        if check_script_exists "sync-vault.sh"; then
            bash "sync-vault.sh"
            SYNC_EXIT_CODE=$?
        else
            print_error "No compatible sync script found"
            exit 1
        fi
    fi
    
    # Check sync result
    if [[ $SYNC_EXIT_CODE -eq 0 ]]; then
        print_success "Vault sync completed successfully!"
    else
        print_error "Vault sync failed with exit code: $SYNC_EXIT_CODE"
        exit $SYNC_EXIT_CODE
    fi
}

# Run main function
main "$@"
