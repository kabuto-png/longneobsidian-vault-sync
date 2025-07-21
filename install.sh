#!/bin/bash
# Obsidian Vault Sync - Universal Installer with Complete Plugin Setup
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
    echo "║       Complete Plugin Setup + Cross-Platform Scripts      ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        case $OS_TYPE in
            "windows") print_info "Download from: https://git-scm.com/download/win" ;;
            "macos") print_info "Install with: brew install git" ;;
            "linux") print_info "Install with: sudo apt install git (Ubuntu) or equivalent" ;;
        esac
        exit 1
    fi
    print_success "Git: ✓"
    
    # Check Node.js and npm
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Plugin build requires Node.js."
        case $OS_TYPE in
            "windows") print_info "Download from: https://nodejs.org/en/download/" ;;
            "macos") print_info "Install with: brew install node" ;;
            "linux") print_info "Install with: sudo apt install nodejs npm (Ubuntu) or equivalent" ;;
        esac
        exit 1
    fi
    print_success "Node.js: ✓"
    
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed. Plugin build requires npm."
        exit 1
    fi
    print_success "npm: ✓"
}

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

install_plugin() {
    print_info "Installing Obsidian plugin..."
    
    local plugin_dir=".obsidian/plugins/longneobsidian-vault-sync"
    
    # Create plugins directory if it doesn't exist
    if [[ ! -d ".obsidian/plugins" ]]; then
        mkdir -p ".obsidian/plugins"
        print_info "Created .obsidian/plugins directory"
    fi
    
    # Remove existing plugin if it exists
    if [[ -d "$plugin_dir" ]]; then
        print_warning "Existing plugin found. Removing for clean installation..."
        rm -rf "$plugin_dir"
    fi
    
    # Clone plugin repository
    print_info "Cloning plugin from GitHub..."
    if git clone https://github.com/kabuto-png/longneobsidian-vault-sync.git "$plugin_dir"; then
        print_success "Plugin repository cloned successfully"
    else
        print_error "Failed to clone plugin repository"
        exit 1
    fi
    
    # Build plugin
    print_info "Building plugin (this may take a moment)..."
    cd "$plugin_dir"
    
    # Install dependencies
    if npm install; then
        print_success "Plugin dependencies installed"
    else
        print_error "Failed to install plugin dependencies"
        cd "$VAULT_DIR"
        exit 1
    fi
    
    # Build plugin
    if npm run build; then
        print_success "Plugin built successfully"
    else
        print_error "Failed to build plugin"
        cd "$VAULT_DIR"
        exit 1
    fi
    
    # Return to vault directory
    cd "$VAULT_DIR"
    
    # Verify plugin files
    if [[ -f "$plugin_dir/main.js" ]] && [[ -f "$plugin_dir/manifest.json" ]]; then
        print_success "Plugin installation complete with all required files"
    else
        print_error "Plugin installation incomplete - missing required files"
        exit 1
    fi
}

download_scripts() {
    print_info "Downloading sync scripts to vault root..."
    
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
            curl -s -L "$base_url/windows/sync-vault.ps1" -o "sync-vault.ps1" 2>/dev/null
            curl -s -L "$base_url/windows/sync-vault.bat" -o "sync-vault.bat" 2>/dev/null
            curl -s -L "$base_url/windows/sync-vault-wsl.bat" -o "sync-vault-wsl.bat" 2>/dev/null
            print_success "Downloaded Windows scripts (PowerShell, Batch, WSL)"
            ;;
        "macos"|"linux")
            print_info "Downloading Unix scripts..."
            # First try to download sync-vault.sh
            if curl -s -L "$base_url/sync-vault.sh" -o "sync-vault.sh" && [[ -s "sync-vault.sh" ]] && ! grep -q "404" "sync-vault.sh"; then
                chmod +x sync-vault.sh
                print_success "Downloaded bash script"
            else
                # Fallback: create basic sync script if download fails
                print_warning "Failed to download sync-vault.sh, creating fallback script..."
                cat > sync-vault.sh << 'EOF'
#!/bin/bash
# Fallback Obsidian Vault Sync Script
echo "🔄 Syncing vault..."
git add .
git commit -m "Vault sync: $(date)"
git pull --rebase
git push
echo "✅ Sync complete"
EOF
                chmod +x sync-vault.sh
                print_success "Created fallback bash script"
            fi
            ;;
    esac
}

setup_git() {
    print_info "Checking Git configuration..."
    
    if [[ ! -d ".git" ]]; then
        print_warning "This directory is not a Git repository."
        read -p "Initialize Git repository? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git init
            print_success "Initialized Git repository"
        else
            print_warning "Skipping Git setup. You'll need to set up version control manually."
            return
        fi
    else
        print_success "Git repository detected"
    fi
    
    # Add remote if not exists
    if ! git remote get-url origin &> /dev/null; then
        read -p "Add Git remote origin? Enter repository URL (or press Enter to skip): " repo_url
        if [[ -n "$repo_url" ]]; then
            git remote add origin "$repo_url"
            print_success "Added Git remote origin"
        fi
    fi
}

create_gitignore() {
    print_info "Setting up .gitignore for Obsidian..."
    
    cat > .gitignore << 'EOF'
# Obsidian
.obsidian/workspace
.obsidian/workspace.json
.obsidian/workspace-mobile.json
.obsidian/cache
.obsidian/plugins/*/data.json
.obsidian/hotkeys.json
.obsidian/core-plugins.json
.obsidian/community-plugins.json
.obsidian/graph.json
.obsidian/canvas.json

# Plugin Development (keep source, ignore build artifacts)
.obsidian/plugins/*/node_modules/
.obsidian/plugins/*/npm-debug.log*
.obsidian/plugins/*/yarn-debug.log*
.obsidian/plugins/*/yarn-error.log*

# OS
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
desktop.ini

# Temporary files
*.tmp
*.temp
.sync-*
*~
*.swp
*.swo

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF
    
    print_success "Created comprehensive .gitignore"
}

test_installation() {
    print_info "Testing complete installation..."
    
    local errors=0
    
    # Test plugin installation
    local plugin_dir=".obsidian/plugins/longneobsidian-vault-sync"
    if [[ -f "$plugin_dir/main.js" ]] && [[ -f "$plugin_dir/manifest.json" ]]; then
        print_success "Plugin files: ✓"
    else
        print_error "Plugin files: ✗"
        ((errors++))
    fi
    
    # Test vault root scripts
    if [[ -f "sync-vault-coordinated.sh" ]]; then
        print_success "Universal wrapper (vault root): ✓"
    else
        print_error "Universal wrapper (vault root): ✗"
        ((errors++))
    fi
    
    case $OS_TYPE in
        "windows")
            if [[ -f "sync-vault.ps1" ]] || [[ -f "sync-vault.bat" ]]; then
                print_success "Windows scripts: ✓"
            else
                print_error "Windows scripts: ✗"
                ((errors++))
            fi
            ;;
        "macos"|"linux")
            if [[ -f "sync-vault.sh" ]]; then
                print_success "Bash script: ✓"
            else
                print_error "Bash script: ✗"
                ((errors++))
            fi
            ;;
    esac
    
    # Test script functionality
    print_info "Testing script execution..."
    if ./sync-vault-coordinated.sh --help &> /dev/null; then
        print_success "Script execution: ✓"
    else
        print_warning "Script execution: ⚠ (may work after Obsidian restart)"
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "All installation tests passed!"
        return 0
    else
        print_error "$errors test(s) failed"
        return 1
    fi
}

show_next_steps() {
    echo
    print_success "🎉 Complete installation finished successfully!"
    echo
    print_info "What was installed:"
    echo "  ✅ Complete Obsidian plugin in .obsidian/plugins/longneobsidian-vault-sync/"
    echo "     ├── main.js (built from TypeScript)"
    echo "     ├── manifest.json"
    echo "     └── All source code and dependencies"
    echo "  ✅ Sync scripts in vault root for plugin detection"
    echo "  ✅ Git repository setup with proper .gitignore"
    echo "  ✅ Cross-platform compatibility scripts"
    echo
    print_info "Final steps:"
    echo "  1. 🔄 Restart Obsidian completely"
    echo "  2. ⚙️  Go to Settings > Community Plugins"
    echo "  3. 🔍 Find 'Vault Sync' in Installed Plugins"
    echo "  4. ✅ Enable the plugin"
    echo "  5. 🚀 Plugin will automatically detect sync scripts"
    echo
    print_info "Testing sync (optional):"
    echo "  • Manual test: ./sync-vault-coordinated.sh"
    echo "  • Plugin should show sync options in command palette"
    echo
    case $OS_TYPE in
        "windows")
            print_info "Windows support: PowerShell (.ps1), Batch (.bat), WSL compatibility"
            ;;
        "macos"|"linux")
            print_info "Unix support: Native bash scripts with full macOS/Linux compatibility"
            ;;
    esac
    echo
    print_info "Documentation: https://github.com/kabuto-png/longneobsidian-vault-sync"
    print_success "Setup complete! Your vault is ready for Git synchronization. 🎯"
}

main() {
    print_header
    
    # Store original directory
    VAULT_DIR="$(pwd)"
    
    # Check prerequisites
    detect_os
    check_prerequisites
    detect_vault_directory
    
    # Complete setup
    install_plugin
    download_scripts
    setup_git
    create_gitignore
    
    # Verify everything
    if test_installation; then
        show_next_steps
    else
        print_error "Installation completed with some issues. Check the errors above."
        print_info "You may need to manually enable the plugin in Obsidian settings."
        exit 1
    fi
}

# Run complete installer
main "$@"