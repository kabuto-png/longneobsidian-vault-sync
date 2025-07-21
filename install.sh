#!/bin/bash
# Obsidian Vault Sync - Universal Installer
# One-command setup for Windows, macOS, and Linux users

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║              Obsidian Vault Sync Installer                ║"
    echo "║            Universal Cross-Platform Setup                 ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

detect_vault_directory() {
    print_info "Detecting Obsidian vault directory..."
    
    # Check if we're already in a vault
    if [[ -d ".obsidian" ]]; then
        VAULT_DIR="$(pwd)"
        print_success "Found vault directory: $VAULT_DIR"
        return 0
    fi
    
    # Search common vault locations
    local common_paths=(
        "$HOME/Documents/Obsidian"
        "$HOME/Documents"
        "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
        "$HOME/Dropbox"
        "$HOME/OneDrive"
        "."
    )
    
    print_info "Searching for Obsidian vaults in common locations..."
    
    for path in "${common_paths[@]}"; do
        if [[ -d "$path" ]]; then
            find "$path" -name ".obsidian" -type d 2>/dev/null | while read -r obsidian_dir; do
                vault_path="$(dirname "$obsidian_dir")"
                echo "Found vault: $vault_path"
            done
        fi
    done
    
    echo
    print_warning "Please navigate to your Obsidian vault directory and run this installer again."
    print_info "Example: cd '/path/to/your/vault' && bash <(curl -s https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main/install.sh)"
    exit 1
}

detect_os() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]] || [[ "$OS" == "Windows_NT" ]]; then
        OS_TYPE="windows"
        print_info "Windows environment detected"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS_TYPE="macos"
        print_info "macOS environment detected"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS_TYPE="linux"
        print_info "Linux environment detected"
    else
        OS_TYPE="unknown"
        print_warning "Unknown OS detected: $OSTYPE"
    fi
}

download_scripts() {
    print_info "Downloading sync scripts..."
    
    local base_url="https://raw.githubusercontent.com/kabuto-png/longneobsidian-vault-sync/main"
    
    # Download universal wrapper to vault root
    if curl -s -L "$base_url/sync-vault-coordinated.sh" -o "sync-vault-coordinated.sh"; then
        chmod +x sync-vault-coordinated.sh
        print_success "Downloaded universal wrapper"
    else
        print_error "Failed to download universal wrapper"
        exit 1
    fi
    
    # Download OS-specific scripts to vault root
    case $OS_TYPE in
        "windows")
            print_info "Downloading Windows scripts..."
            curl -s -L "$base_url/windows/sync-vault.ps1" -o "sync-vault.ps1"
            curl -s -L "$base_url/windows/sync-vault.bat" -o "sync-vault.bat"
            curl -s -L "$base_url/windows/sync-vault-wsl.bat" -o "sync-vault-wsl.bat"
            print_success "Downloaded Windows scripts (PowerShell, Batch, WSL)"
            ;;
        "macos"|"linux")
            print_info "Downloading Unix scripts..."
            if curl -s -L "$base_url/sync-vault.sh" -o "sync-vault.sh"; then
                chmod +x sync-vault.sh
                print_success "Downloaded bash script"
            else
                print_error "Failed to download bash script"
                exit 1
            fi
            ;;
    esac
    
    # Check if plugin already exists
    local plugin_dir=".obsidian/plugins/longneobsidian-vault-sync"
    if [[ -d "$plugin_dir" ]] && [[ -f "$plugin_dir/manifest.json" ]]; then
        print_info "Existing plugin installation detected - keeping current plugin"
        print_info "Plugin location: $plugin_dir"
    else
        print_warning "No existing plugin found at $plugin_dir"
        print_info "Please install the 'Vault Sync' plugin from Obsidian Community Plugins"
        print_info "Or manually install from: https://github.com/kabuto-png/longneobsidian-vault-sync"
    fi
}

setup_git() {
    print_info "Checking Git configuration..."
    
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        case $OS_TYPE in
            "windows") print_info "Download from: https://git-scm.com/download/win" ;;
            "macos") print_info "Install with: brew install git" ;;
            "linux") print_info "Install with: sudo apt install git (Ubuntu) or equivalent" ;;
        esac
        exit 1
    fi
    
    if [[ ! -d ".git" ]]; then
        print_warning "This directory is not a Git repository."
        read -p "Initialize Git repository? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git init
            print_success "Initialized Git repository"
        else
            print_warning "Skipping Git setup. You'll need to set up version control manually."
        fi
    else
        print_success "Git repository detected"
    fi
}

create_gitignore() {
    print_info "Setting up .gitignore for Obsidian..."
    
    cat > .gitignore << 'EOF'
# Obsidian
.obsidian/workspace
.obsidian/workspace.json
.obsidian/cache
.obsidian/plugins/*/data.json
.obsidian/hotkeys.json
.obsidian/core-plugins.json
.obsidian/community-plugins.json

# OS
.DS_Store
Thumbs.db
desktop.ini

# Temporary files
*.tmp
*.temp
.sync-*
EOF
    
    print_success "Created .gitignore"
}

test_installation() {
    print_info "Testing installation..."
    
    # Test vault root scripts
    if [[ -f "sync-vault-coordinated.sh" ]]; then
        print_success "Universal wrapper (vault root): ✓"
    else
        print_error "Universal wrapper (vault root): ✗"
        return 1
    fi
    
    case $OS_TYPE in
        "windows")
            if [[ -f "sync-vault.ps1" ]] || [[ -f "sync-vault.bat" ]]; then
                print_success "Windows scripts: ✓"
            else
                print_error "Windows scripts: ✗"
                return 1
            fi
            ;;
        "macos"|"linux")
            if [[ -f "sync-vault.sh" ]]; then
                print_success "Bash script: ✓"
            else
                print_error "Bash script: ✗"
                return 1
            fi
            ;;
    esac
    
    # Check plugin (optional)
    local plugin_dir=".obsidian/plugins/longneobsidian-vault-sync"
    if [[ -d "$plugin_dir" ]] && [[ -f "$plugin_dir/manifest.json" ]]; then
        print_success "Plugin installation: ✓"
    else
        print_warning "Plugin installation: ✗ (install manually from Community Plugins)"
    fi
    
    print_success "Installation test passed!"
    return 0
}

show_next_steps() {
    echo
    print_success "🎉 Installation completed successfully!"
    echo
    print_info "Next steps:"
    echo "  1. Install 'Vault Sync' plugin from Obsidian Community Plugins"
    echo "     OR manually install from: https://github.com/kabuto-png/longneobsidian-vault-sync"
    echo "  2. The plugin will automatically detect: sync-vault-coordinated.sh"
    echo "  3. Test sync manually: ./sync-vault-coordinated.sh"
    echo
    print_info "The installer has set up:"
    echo "  ✓ Universal wrapper script (auto-detects your OS)"
    echo "  ✓ Platform-specific sync scripts in vault root"
    case $OS_TYPE in
        "windows")
            echo "  ✓ Windows: PowerShell (.ps1), Batch (.bat), WSL (.bat)"
            ;;
        "macos"|"linux")
            echo "  ✓ Unix: Bash script (.sh)"
            ;;
    esac
    echo "  ✓ Git configuration"
    echo "  ✓ Obsidian .gitignore"
    echo
    print_info "Documentation: https://github.com/kabuto-png/longneobsidian-vault-sync"
}

main() {
    print_header
    
    # Check prerequisites
    detect_vault_directory
    detect_os
    
    # Setup
    download_scripts
    setup_git
    create_gitignore
    
    # Verify
    if test_installation; then
        show_next_steps
    else
        print_error "Installation failed. Please check the errors above."
        exit 1
    fi
}

# Run installer
main "$@"
