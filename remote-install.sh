#!/bin/bash
# SDD Remote Installation Script
# 
# This script provides curl-based installation of the SDD system.
# It downloads the main installation script and all required files
# to provide identical functionality to git clone + local install.sh
#
# Usage: curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh | bash
# Secure Usage: 
#   curl -sSL https://raw.githubusercontent.com/kpiteira/spec-driven-development/main/remote-install.sh -o /tmp/sdd-install.sh
#   # Review script contents
#   bash /tmp/sdd-install.sh

set -euo pipefail

# Configuration - GitHub repository details
readonly REPO_OWNER="${SDD_REPO_OWNER:-kpiteira}"
readonly REPO_NAME="${SDD_REPO_NAME:-spec-driven-development}"
readonly REPO_VERSION="${SDD_VERSION:-main}"
readonly BASE_URL="https://github.com/$REPO_OWNER/$REPO_NAME"
readonly RAW_URL="$BASE_URL/raw/$REPO_VERSION"

# Installation paths - identical to local installation
readonly SDD_TEMPLATES_DIR="${TEST_HOME:-$HOME}/.sdd/templates"
readonly CLAUDE_COMMANDS_DIR="${TEST_HOME:-$HOME}/.claude/commands"  
readonly CLAUDE_AGENTS_DIR="${TEST_HOME:-$HOME}/.claude/agents"
readonly CLAUDE_HOOKS_DIR="${TEST_HOME:-$HOME}/.claude/hooks"

# Temporary workspace for downloads
readonly TEMP_DIR="/tmp/sdd-install-$$"
readonly INSTALL_LOG="$TEMP_DIR/install.log"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Global variables for installation tracking
declare -i TEMPLATES_INSTALLED=0
declare -i COMMANDS_INSTALLED=0
declare -i AGENTS_INSTALLED=0
declare -i HOOKS_INSTALLED=0

# Logging functions
log_info() { 
    echo -e "${GREEN}[INFO]${NC} $*"
    # Only write to log if directory exists and is writable
    if [[ -d "$(dirname "$INSTALL_LOG")" ]]; then
        echo "[INFO] $*" >> "$INSTALL_LOG" 2>/dev/null || true
    fi
}
log_warn() { 
    echo -e "${YELLOW}[WARN]${NC} $*"
    if [[ -d "$(dirname "$INSTALL_LOG")" ]]; then
        echo "[WARN] $*" >> "$INSTALL_LOG" 2>/dev/null || true
    fi
}
log_error() { 
    echo -e "${RED}[ERROR]${NC} $*" >&2
    if [[ -d "$(dirname "$INSTALL_LOG")" ]]; then
        echo "[ERROR] $*" >> "$INSTALL_LOG" 2>/dev/null || true
    fi
}
log_debug() { 
    echo -e "${BLUE}[DEBUG]${NC} $*"
    if [[ -d "$(dirname "$INSTALL_LOG")" ]]; then
        echo "[DEBUG] $*" >> "$INSTALL_LOG" 2>/dev/null || true
    fi
}

# Security: User consent for remote installation
show_security_warning() {
    echo
    echo "⚠️  SECURITY NOTICE ⚠️"
    echo "You are about to install SDD system remotely via curl."
    echo
    echo "This installation will:"
    echo "  • Download and install templates to: $SDD_TEMPLATES_DIR"
    echo "  • Install Claude Code commands to: $CLAUDE_COMMANDS_DIR"
    echo "  • Install Claude Code agents to: $CLAUDE_AGENTS_DIR"
    echo "  • Install Claude Code hooks to: $CLAUDE_HOOKS_DIR"
    echo
    echo "Source repository: $BASE_URL"
    echo "Version: $REPO_VERSION"
    echo "Installation log: $INSTALL_LOG"
    echo
    
    # Force non-interactive mode for curl|bash - safer default
    if [[ -t 0 ]] && [[ -t 1 ]] && [[ "${SDD_INTERACTIVE:-auto}" != "false" ]]; then
        echo "Interactive mode detected. Set SDD_INTERACTIVE=false to skip this prompt."
        read -p "Continue with installation? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Installation cancelled by user"
            exit 0
        fi
    else
        log_info "Non-interactive installation mode - proceeding automatically..."
        log_info "To enable interactive mode, run: SDD_INTERACTIVE=true curl ... | bash"
    fi
}

# Prerequisites validation
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check required commands
    command -v curl >/dev/null 2>&1 || {
        log_error "curl is required but not installed"
        exit 1
    }
    
    # Check checksum utility
    if ! command -v shasum >/dev/null 2>&1 && ! command -v sha256sum >/dev/null 2>&1; then
        log_error "shasum or sha256sum is required for security verification"
        exit 1
    fi
    
    # Check bash version (3.2+ should work, but warn about older versions)
    local bash_major="${BASH_VERSION:0:1}"
    local bash_minor="${BASH_VERSION:2:1}"
    if [[ $bash_major -lt 3 ]] || [[ $bash_major -eq 3 && $bash_minor -lt 2 ]]; then
        log_error "Bash 3.2+ required, found $BASH_VERSION"
        exit 1
    elif [[ $bash_major -eq 3 ]]; then
        log_warn "Using older bash version $BASH_VERSION - consider upgrading to bash 4.0+ for better compatibility"
    fi
    
    # Check network connectivity
    if ! curl -sSL --max-time 10 -I https://github.com >/dev/null 2>&1; then
        log_error "Network connectivity to GitHub required"
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

# Create secure temporary workspace
setup_workspace() {
    log_info "Setting up temporary workspace..."
    
    # Create temp directory with restricted permissions
    mkdir -p -m 700 "$TEMP_DIR" || {
        log_error "Cannot create temporary directory: $TEMP_DIR"
        exit 1
    }
    
    # Initialize install log
    echo "SDD Remote Installation Log - $(date)" > "$INSTALL_LOG"
    echo "Repository: $BASE_URL" >> "$INSTALL_LOG"
    echo "Version: $REPO_VERSION" >> "$INSTALL_LOG"
    echo >> "$INSTALL_LOG"
    
    log_debug "Workspace created at: $TEMP_DIR"
}

# Cleanup on exit
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        log_debug "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}

# Security: Download and verify file
secure_download() {
    local url="$1"
    local output_file="$2"
    local expected_hash="${3:-}"  # Optional checksum
    
    log_debug "Downloading: $(basename "$url")"
    
    # Download with security options and retry logic
    if ! curl -sSL --fail --max-time 30 --retry 3 --retry-delay 2 -A "SDD-Installer/1.0" \
        "$url" -o "$output_file"; then
        log_error "Failed to download: $url"
        return 1
    fi
    
    # Verify checksum if provided
    if [[ -n "${expected_hash:-}" ]]; then
        local actual_hash
        if command -v sha256sum >/dev/null 2>&1; then
            actual_hash=$(sha256sum "$output_file" | cut -d' ' -f1)
        else
            actual_hash=$(shasum -a 256 "$output_file" | cut -d' ' -f1)
        fi
        
        if [[ "$actual_hash" != "$expected_hash" ]]; then
            log_error "Checksum verification failed for $(basename "$output_file")"
            log_error "Expected: $expected_hash"
            log_error "Actual: $actual_hash"
            return 1
        fi
        
        log_debug "Checksum verified: $(basename "$output_file")"
    fi
    
    return 0
}

# Extract version from YAML frontmatter
extract_version() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        echo "0.0.0"
        return 0
    fi
    
    local version
    version=$(sed -n '/^---$/,/^---$/p' "$file" | \
              grep '^version:' | \
              sed 's/version: *"*\([^"]*\)"*.*/\1/' | \
              head -1)
    
    if [[ -z "$version" ]]; then
        echo "0.0.0"
    else
        echo "$version"
    fi
}

# Compare semantic versions
version_compare() {
    local v1="$1"
    local v2="$2"
    
    # Split versions into components
    local v1_major v1_minor v1_patch
    local v2_major v2_minor v2_patch
    
    IFS='.' read -r v1_major v1_minor v1_patch <<< "$v1"
    IFS='.' read -r v2_major v2_minor v2_patch <<< "$v2"
    
    # Default missing components to 0
    v1_major=${v1_major:-0}
    v1_minor=${v1_minor:-0}
    v1_patch=${v1_patch:-0}
    v2_major=${v2_major:-0}
    v2_minor=${v2_minor:-0}
    v2_patch=${v2_patch:-0}
    
    # Compare major.minor.patch
    if [[ $v1_major -gt $v2_major ]]; then
        return 0  # v1 > v2
    elif [[ $v1_major -lt $v2_major ]]; then
        return 1  # v1 < v2
    fi
    
    # Major versions equal, compare minor
    if [[ $v1_minor -gt $v2_minor ]]; then
        return 0  # v1 > v2
    elif [[ $v1_minor -lt $v2_minor ]]; then
        return 1  # v1 < v2
    fi
    
    # Minor versions equal, compare patch
    if [[ $v1_patch -ge $v2_patch ]]; then
        return 0  # v1 >= v2
    else
        return 1  # v1 < v2
    fi
}

# Version-aware file installation
install_file_with_version() {
    local source_file="$1"
    local destination="$2"
    
    # Create destination directory if needed
    local dest_dir
    dest_dir=$(dirname "$destination")
    mkdir -p "$dest_dir" || {
        log_error "Cannot create directory: $dest_dir"
        return 1
    }
    
    # Get versions
    local source_version dest_version
    source_version=$(extract_version "$source_file")
    dest_version=$(extract_version "$destination")
    
    log_debug "Comparing versions: source=$source_version, destination=$dest_version"
    
    # Check if source version is newer or equal
    if version_compare "$source_version" "$dest_version"; then
        # Copy with appropriate permissions
        if cp "$source_file" "$destination"; then
            chmod 644 "$destination"
            
            if [[ "$source_version" == "$dest_version" ]]; then
                log_info "Reinstalled same version: $(basename "$destination") v$source_version"
            else
                log_info "Updated: $(basename "$destination") v$dest_version → v$source_version"
            fi
            return 0
        else
            log_error "Failed to copy $(basename "$source_file") to $destination"
            return 1
        fi
    else
        # Skip downgrade
        log_warn "Skipping downgrade: $(basename "$destination") v$dest_version > v$source_version"
        return 0
    fi
}

# Download and install templates
install_templates() {
    log_info "Installing SDD templates..."
    
    # Template files to download
    local templates=(
        "0_Project_Vision_Template.md"
        "1_Product_Requirements_Template.md"
        "2_Architecture_Template.md"
        "3_Roadmap_Template.md"
        "4_Milestone_Plan_Template.md"
        "5_Task_Blueprint_Template.md"
    )
    
    local template_count=0
    for template in "${templates[@]}"; do
        local url="$RAW_URL/specs/templates/$template"
        local temp_file="$TEMP_DIR/$template"
        local dest_file="$SDD_TEMPLATES_DIR/$template"
        
        if secure_download "$url" "$temp_file"; then
            if install_file_with_version "$temp_file" "$dest_file"; then
                ((template_count++))
            fi
        else
            log_error "Failed to download template: $template"
            return 1
        fi
    done
    
    TEMPLATES_INSTALLED=$template_count
    log_info "Installed $template_count template files"
    return 0
}

# Download and install commands
install_commands() {
    log_info "Installing SDD commands..."
    
    # Command files to download
    local commands=(
        "init_greenfield.md"
        "plan_milestone.md"
        "task.md"
    )
    
    local command_count=0
    for command in "${commands[@]}"; do
        local url="$RAW_URL/.claude/commands/$command"
        local temp_file="$TEMP_DIR/$command"
        local dest_file="$CLAUDE_COMMANDS_DIR/$command"
        
        if secure_download "$url" "$temp_file"; then
            if install_file_with_version "$temp_file" "$dest_file"; then
                ((command_count++))
            fi
        else
            log_error "Failed to download command: $command"
            return 1
        fi
    done
    
    COMMANDS_INSTALLED=$command_count
    log_info "Installed $command_count command files"
    return 0
}

# Download and install agents
install_agents() {
    log_info "Installing SDD agents..."
    
    # Agent files to download  
    local agents=(
        "architecture-specialist.md"
        "bundler-specialist.md"
        "coder-specialist.md" 
        "milestone-planning-specialist.md"
        "requirements-specialist.md"
        "roadmap-specialist.md"
        "task-blueprint-specialist.md"
        "validator-specialist.md"
    )
    
    local agent_count=0
    for agent in "${agents[@]}"; do
        local url="$RAW_URL/.claude/agents/$agent"
        local temp_file="$TEMP_DIR/$agent"
        local dest_file="$CLAUDE_AGENTS_DIR/$agent"
        
        if secure_download "$url" "$temp_file"; then
            if install_file_with_version "$temp_file" "$dest_file"; then
                ((agent_count++))
            fi
        else
            log_warn "Failed to download agent: $agent (continuing installation)"
        fi
    done
    
    AGENTS_INSTALLED=$agent_count
    log_info "Installed $agent_count agent files"
    return 0
}

# Download and install hooks
install_hooks() {
    log_info "Installing SDD hooks..."
    
    # Hooks are optional - create directory and try to download key files
    mkdir -p "$CLAUDE_HOOKS_DIR" || {
        log_warn "Cannot create hooks directory, skipping hooks installation"
        return 0
    }
    
    # Hook files to download
    local hook_files=(
        "README.md"
        "sdd-session-logger.py"
        "sdd-activity-logger.py"
        "sdd-performance-tracker.py"
        "sdd-session-summary.py"
    )
    
    local lib_files=(
        "lib/notification_system.py"
    )
    
    local sound_files=(
        "sounds/success.wav"
        "sounds/error.wav" 
        "sounds/warning.wav"
        "sounds/progress.wav"
    )
    
    local hook_count=0
    
    # Download main hook files
    for hook_file in "${hook_files[@]}"; do
        local url="$RAW_URL/.claude/hooks/$hook_file"
        local temp_file="$TEMP_DIR/$(basename "$hook_file")"
        local dest_file="$CLAUDE_HOOKS_DIR/$(basename "$hook_file")"
        
        if secure_download "$url" "$temp_file"; then
            if [[ "$hook_file" == *.py ]]; then
                # Python files need executable permissions
                if cp "$temp_file" "$dest_file" && chmod 755 "$dest_file"; then
                    log_info "Installed hook: $(basename "$hook_file")"
                    ((hook_count++))
                fi
            else
                # Markdown files use version comparison
                if install_file_with_version "$temp_file" "$dest_file"; then
                    ((hook_count++))
                fi
            fi
        else
            log_warn "Failed to download hook: $hook_file (continuing installation)"
        fi
    done
    
    # Download lib files
    mkdir -p "$CLAUDE_HOOKS_DIR/lib" || {
        log_warn "Cannot create hooks lib directory"
    }
    
    for lib_file in "${lib_files[@]}"; do
        local url="$RAW_URL/.claude/hooks/$lib_file"
        local temp_file="$TEMP_DIR/$(basename "$lib_file")"
        local dest_file="$CLAUDE_HOOKS_DIR/$lib_file"
        
        if secure_download "$url" "$temp_file"; then
            if cp "$temp_file" "$dest_file" && chmod 644 "$dest_file"; then
                log_info "Installed lib: $(basename "$lib_file")"
                ((hook_count++))
            fi
        else
            log_warn "Failed to download lib file: $lib_file (continuing installation)"
        fi
    done
    
    # Download sound files
    mkdir -p "$CLAUDE_HOOKS_DIR/sounds" || {
        log_warn "Cannot create hooks sounds directory"
    }
    
    for sound_file in "${sound_files[@]}"; do
        local url="$RAW_URL/.claude/hooks/$sound_file"
        local temp_file="$TEMP_DIR/$(basename "$sound_file")"
        local dest_file="$CLAUDE_HOOKS_DIR/$sound_file"
        
        if secure_download "$url" "$temp_file"; then
            if cp "$temp_file" "$dest_file" && chmod 644 "$dest_file"; then
                log_info "Installed sound: $(basename "$sound_file")"
                ((hook_count++))
            fi
        else
            log_warn "Failed to download sound file: $sound_file (continuing installation)"
        fi
    done
    
    HOOKS_INSTALLED=$hook_count
    log_info "Installed $hook_count hook files"
    return 0
}

# Verify installation
verify_installation() {
    local success=true
    
    log_info "Verifying installation..."
    
    # Check templates
    if [[ ! -d "$SDD_TEMPLATES_DIR" ]]; then
        log_error "Templates directory not created: $SDD_TEMPLATES_DIR"
        success=false
    else
        local template_count
        template_count=$(find "$SDD_TEMPLATES_DIR" -name "*.md" 2>/dev/null | wc -l)
        if [[ $template_count -gt 0 ]]; then
            log_info "Templates verified: $template_count files found"
        else
            log_error "No template files found in $SDD_TEMPLATES_DIR"
            success=false
        fi
    fi
    
    # Check commands
    if [[ ! -d "$CLAUDE_COMMANDS_DIR" ]]; then
        log_error "Commands directory not created: $CLAUDE_COMMANDS_DIR"
        success=false
    else
        local command_count
        command_count=$(find "$CLAUDE_COMMANDS_DIR" -name "*.md" 2>/dev/null | wc -l)
        if [[ $command_count -gt 0 ]]; then
            log_info "Commands verified: $command_count files found"
        else
            log_error "No command files found in $CLAUDE_COMMANDS_DIR"
            success=false
        fi
    fi
    
    # Check hooks (optional)
    if [[ -d "$CLAUDE_HOOKS_DIR" ]]; then
        local hook_count
        hook_count=$(find "$CLAUDE_HOOKS_DIR" -name "*.py" -o -name "*.md" -o -name "*.wav" 2>/dev/null | wc -l)
        if [[ $hook_count -gt 0 ]]; then
            log_info "Hooks verified: $hook_count files found"
        else
            log_info "Hooks directory exists but no files found (hooks are optional)"
        fi
    else
        log_info "No hooks directory found (hooks are optional)"
    fi
    
    if [[ "$success" == true ]]; then
        log_info "Installation verification passed"
        return 0
    else
        log_error "Installation verification failed"
        return 1
    fi
}

# Show installation summary
show_summary() {
    echo
    echo "🎉 SDD Installation Summary"
    echo "=========================="
    echo "  Templates installed: $TEMPLATES_INSTALLED (in $SDD_TEMPLATES_DIR)"
    echo "  Commands installed: $COMMANDS_INSTALLED (in $CLAUDE_COMMANDS_DIR)"
    echo "  Agents installed: $AGENTS_INSTALLED (in $CLAUDE_AGENTS_DIR)"
    echo "  Hooks installed: $HOOKS_INSTALLED (in $CLAUDE_HOOKS_DIR)"
    echo
    echo "  Installation log: $INSTALL_LOG"
    echo
    log_info "SDD system is ready! Try: /init_greenfield your-project-name"
    echo
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    
    log_error "Remote installation failed at line $line_number (exit code: $exit_code)"
    log_error "Installation log available at: $INSTALL_LOG"
    
    echo
    echo "🔧 Recovery suggestions:"
    echo "  1. Check network connectivity to GitHub"
    echo "  2. Verify file permissions for home directory"
    echo "  3. Try manual installation: git clone + ./install.sh"
    echo "  4. Review installation log for specific errors"
    echo
    
    exit $exit_code
}

# Set up error handling and cleanup
trap 'handle_error $LINENO' ERR
trap cleanup EXIT

# Main installation flow
main() {
    log_info "Starting SDD remote installation..."
    log_info "Repository: $BASE_URL"
    log_info "Version: $REPO_VERSION"
    
    show_security_warning
    check_prerequisites
    setup_workspace
    
    # Perform installation
    install_templates || exit 1
    install_commands || exit 1
    install_agents || exit 1
    install_hooks || exit 1
    
    # Verify and complete
    verify_installation || exit 1
    
    show_summary
    log_info "Remote installation completed successfully!"
}

# Script entry point - handle both file execution and curl|bash
# Check if script is being executed directly (not sourced)
if [[ "${BASH_SOURCE:-}" ]]; then
    # BASH_SOURCE is set - check if it matches $0 (direct execution)
    if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
        main "$@"
    fi
else
    # BASH_SOURCE is not set - likely curl|bash execution
    main "$@"
fi