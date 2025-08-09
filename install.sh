#!/bin/bash
# SDD (Spec-Driven Development) System Installation Script
# 
# This script installs the SDD system by:
# 1. Installing specification templates to ~/.sdd/templates/ (version-aware)
# 2. Installing Claude Code commands to ~/.claude/commands/ (version-aware)
# 3. Installing Claude Code agents to ~/.claude/agents/ (version-aware)
# 4. Validating the installation
# 
# Version Management:
# - Only installs files with newer or equal versions
# - Prevents accidental downgrades
# - No backup files created (clean installation)

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script metadata
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Installation paths - following bundle_dependencies.md specifications
readonly SDD_TEMPLATES_DIR="${TEST_HOME:-$HOME}/.sdd/templates"
readonly CLAUDE_COMMANDS_DIR="${TEST_HOME:-$HOME}/.claude/commands"  
readonly CLAUDE_AGENTS_DIR="${TEST_HOME:-$HOME}/.claude/agents"

# Source paths (relative to script location) - following bundle_code_context.md
readonly TEMPLATES_SOURCE="$SCRIPT_DIR/specs/templates"
readonly COMMANDS_SOURCE="$SCRIPT_DIR/.claude/commands"
readonly AGENTS_SOURCE="$SCRIPT_DIR/.claude/agents"

# Color codes for output - following bundle_code_context.md patterns
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Global variables for installation tracking
declare -i TEMPLATES_INSTALLED=0
declare -i COMMANDS_INSTALLED=0
declare -i AGENTS_INSTALLED=0

# Logging functions - following bundle_code_context.md patterns
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $*"; }

# Security: Path validation function - following bundle_security.md requirements
validate_path() {
    local path="$1"
    local allowed_prefix="$2"
    
    # For relative paths or safe system paths, allow them
    case "$path" in
        .claude/*) return 0 ;;  # Allow .claude directory operations
        ~/.sdd/*) return 0 ;;   # Allow SDD directory operations
        /*) 
            # For absolute paths, do full validation
            local abs_path
            abs_path=$(realpath "$path" 2>/dev/null) || {
                log_error "Invalid path: $path"
                return 1
            }
            
            # Check if path is within allowed directory - path traversal protection
            case "$abs_path" in
                "$allowed_prefix"*) return 0 ;;
                *) log_error "Path $abs_path is outside allowed directory $allowed_prefix"
                   return 1 ;;
            esac
            ;;
        *) return 0 ;;  # Allow relative paths for local operations
    esac
}

# Extract version from YAML frontmatter
extract_version() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "0.0.0"  # Default version if file doesn't exist
        return 0
    fi
    
    # Extract version from YAML frontmatter (between first --- and second ---)
    local version
    version=$(sed -n '/^---$/,/^---$/p' "$file" | grep '^version:' | sed 's/version: *"*\([^"]*\)"*.*/\1/' | head -1)
    
    if [ -z "$version" ]; then
        echo "0.0.0"  # Default version if no version found
    else
        echo "$version"
    fi
}

# Compare semantic versions (returns 0 if v1 >= v2, 1 if v1 < v2)
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
    if [ "$v1_major" -gt "$v2_major" ]; then
        return 0  # v1 > v2
    elif [ "$v1_major" -lt "$v2_major" ]; then
        return 1  # v1 < v2
    fi
    
    # Major versions equal, compare minor
    if [ "$v1_minor" -gt "$v2_minor" ]; then
        return 0  # v1 > v2
    elif [ "$v1_minor" -lt "$v2_minor" ]; then
        return 1  # v1 < v2
    fi
    
    # Minor versions equal, compare patch
    if [ "$v1_patch" -ge "$v2_patch" ]; then
        return 0  # v1 >= v2
    else
        return 1  # v1 < v2
    fi
}

# Version-aware copy - only installs if source version is newer or equal
copy_if_newer_version() {
    local source="$1"
    local destination="$2"
    
    # Check if source and destination are the same file - skip if identical
    if [ "$(realpath "$source" 2>/dev/null)" = "$(realpath "$destination" 2>/dev/null)" ]; then
        log_info "Source and destination identical, skipping: $(basename "$destination")"
        return 0
    fi
    
    # Validate paths - security requirement
    local dest_dir
    dest_dir=$(dirname "$destination")
    # Skip path validation for TEST_HOME scenarios and standard installation paths
    case "$dest_dir" in
        */.sdd/templates|*/.claude/commands|*/.claude/agents) 
            # Standard installation paths - allow
            ;;
        *)
            validate_path "$dest_dir" "$HOME" || return 1
            ;;
    esac
    
    # Get versions
    local source_version dest_version
    source_version=$(extract_version "$source")
    dest_version=$(extract_version "$destination")
    
    log_debug "Comparing versions: source=$source_version, destination=$dest_version"
    
    # Check if source version is newer or equal
    if version_compare "$source_version" "$dest_version"; then
        # Source version >= destination version, proceed with copy
        if cp -p "$source" "$destination"; then
            # Set secure file permissions
            chmod 644 "$destination"
            
            if [ "$source_version" = "$dest_version" ]; then
                log_info "Reinstalled same version: $(basename "$destination") v$source_version"
            else
                log_info "Updated: $(basename "$destination") v$dest_version → v$source_version"
            fi
            return 0
        else
            log_error "Failed to copy $source to $destination"
            return 1
        fi
    else
        # Source version < destination version, skip to prevent downgrade
        log_warn "Skipping downgrade: $(basename "$destination") v$dest_version > v$source_version"
        return 0
    fi
}

# Validate file contents - following bundle_security.md requirements  
validate_markdown_file() {
    local file="$1"
    
    # Check file exists and is readable
    if [ ! -r "$file" ]; then
        log_error "File is not readable: $file"
        return 1
    fi
    
    # Check for YAML frontmatter - basic content validation
    if ! head -1 "$file" | grep -q "^---$"; then
        log_warn "File may not have YAML frontmatter: $(basename "$file")"
        return 0  # Don't fail, just warn
    fi
    
    # Check for version field in frontmatter
    local version
    version=$(extract_version "$file")
    if [ "$version" = "0.0.0" ]; then
        log_warn "File missing version in frontmatter: $(basename "$file")"
    fi
    
    return 0
}

# Validate command file structure - following bundle_code_context.md patterns
validate_command_file() {
    local file="$1"
    
    validate_markdown_file "$file" || return 1
    
    # Check for required frontmatter fields - Claude Code integration requirement
    if ! grep -q "^description:" "$file"; then
        log_error "Command file missing required 'description' field: $(basename "$file")"
        return 1
    fi
    
    return 0
}

# BEHAVIOR 1: Global Template Installation - following task blueprint requirements
install_templates() {
    log_info "Installing SDD templates to $SDD_TEMPLATES_DIR..."
    
    # Validate source directory exists - error handling requirement
    if [ ! -d "$TEMPLATES_SOURCE" ]; then
        log_error "Source templates directory not found: $TEMPLATES_SOURCE"
        return 1
    fi
    
    # Create destination directory with appropriate permissions - security requirement
    if ! mkdir -p -m 755 "$SDD_TEMPLATES_DIR"; then
        log_error "Failed to create templates directory: $SDD_TEMPLATES_DIR"
        return 1
    fi
    
    # Copy templates with validation - following bundle_architecture.md patterns
    local template_count=0
    for template in "$TEMPLATES_SOURCE"/*.md; do
        if [ -f "$template" ]; then
            local filename
            filename=$(basename "$template")
            
            # Validate template file before copying
            if validate_markdown_file "$template"; then
                if copy_if_newer_version "$template" "$SDD_TEMPLATES_DIR/$filename"; then
                    ((template_count++))
                else
                    log_error "Failed to install template: $filename"
                    return 1
                fi
            else
                log_warn "Skipping invalid template: $filename"
            fi
        fi
    done
    
    TEMPLATES_INSTALLED=$template_count
    log_info "Installed $template_count template files"
    return 0
}

# BEHAVIOR 2: Claude Code Commands Installation - following task blueprint requirements
install_commands() {
    log_info "Installing SDD commands to $CLAUDE_COMMANDS_DIR..."
    
    # Validate source directory exists
    if [ ! -d "$COMMANDS_SOURCE" ]; then
        log_error "Source commands directory not found: $COMMANDS_SOURCE"
        return 1
    fi
    
    # Create destination directory with appropriate permissions
    if ! mkdir -p -m 755 "$CLAUDE_COMMANDS_DIR"; then
        log_error "Failed to create commands directory: $CLAUDE_COMMANDS_DIR"
        return 1
    fi
    
    # Copy commands with validation
    local command_count=0
    for command in "$COMMANDS_SOURCE"/*.md; do
        if [ -f "$command" ]; then
            local filename
            filename=$(basename "$command")
            
            # Skip temporary/development files - following bundle_code_context.md guidance
            if [[ "$filename" == *"_temp.md" ]]; then
                log_info "Skipping development file: $filename"
                continue
            fi
            
            # Validate command file before copying
            if validate_command_file "$command"; then
                if copy_if_newer_version "$command" "$CLAUDE_COMMANDS_DIR/$filename"; then
                    ((command_count++))
                else
                    log_error "Failed to install command: $filename"
                    return 1
                fi
            else
                log_warn "Skipping invalid command: $filename"
            fi
        fi
    done
    
    COMMANDS_INSTALLED=$command_count
    log_info "Installed $command_count command files"
    return 0
}

# Optional: Install Claude Code agents
install_agents() {
    log_info "Installing SDD agents to $CLAUDE_AGENTS_DIR..."
    
    # Agents are optional - don't fail if directory doesn't exist
    if [ ! -d "$AGENTS_SOURCE" ]; then
        log_info "No agents directory found - skipping agent installation"
        return 0
    fi
    
    # Create destination directory with appropriate permissions
    if ! mkdir -p -m 755 "$CLAUDE_AGENTS_DIR"; then
        log_error "Failed to create agents directory: $CLAUDE_AGENTS_DIR"
        return 1
    fi
    
    # Copy agents with validation
    local agent_count=0
    for agent in "$AGENTS_SOURCE"/*.md; do
        if [ -f "$agent" ]; then
            local filename
            filename=$(basename "$agent")
            
            # Validate agent file before copying
            if validate_markdown_file "$agent"; then
                if copy_if_newer_version "$agent" "$CLAUDE_AGENTS_DIR/$filename"; then
                    ((agent_count++))
                else
                    log_error "Failed to install agent: $filename"
                    return 1
                fi
            else
                log_warn "Skipping invalid agent: $filename"
            fi
        fi
    done
    
    AGENTS_INSTALLED=$agent_count
    log_info "Installed $agent_count agent files"
    return 0
}

# BEHAVIOR 3: Installation Validation - following task blueprint requirements
verify_installation() {
    local success=true
    
    log_info "Verifying installation..."
    
    # Check templates directory and files
    if [ ! -d "$SDD_TEMPLATES_DIR" ]; then
        log_error "Templates directory not found: $SDD_TEMPLATES_DIR"
        success=false
    else
        local template_count
        template_count=$(find "$SDD_TEMPLATES_DIR" -name "*.md" 2>/dev/null | wc -l)
        if [ "$template_count" -gt 0 ]; then
            log_info "Template verification: $template_count files found"
        else
            log_error "No template files found in $SDD_TEMPLATES_DIR"
            success=false
        fi
    fi
    
    # Check commands directory and files
    if [ ! -d "$CLAUDE_COMMANDS_DIR" ]; then
        log_error "Commands directory not found: $CLAUDE_COMMANDS_DIR"
        success=false
    else
        local command_count
        command_count=$(find "$CLAUDE_COMMANDS_DIR" -name "*.md" 2>/dev/null | wc -l)
        if [ "$command_count" -gt 0 ]; then
            log_info "Commands verification: $command_count files found"
        else
            log_error "No command files found in $CLAUDE_COMMANDS_DIR"
            success=false
        fi
    fi
    
    # Validate command file structure
    for cmd_file in "$CLAUDE_COMMANDS_DIR"/*.md; do
        if [ -f "$cmd_file" ]; then
            if ! validate_command_file "$cmd_file"; then
                log_error "Command file validation failed: $(basename "$cmd_file")"
                success=false
            fi
        fi
    done
    
    if [ "$success" = true ]; then
        log_info "Installation verification passed"
        return 0
    else
        log_error "Installation verification failed"
        return 1
    fi
}

# Show installation summary
show_installation_summary() {
    log_info "Installation Summary:"
    echo "  Templates installed: $TEMPLATES_INSTALLED (in $SDD_TEMPLATES_DIR)"
    echo "  Commands installed: $COMMANDS_INSTALLED (in $CLAUDE_COMMANDS_DIR)"
    echo "  Agents installed: $AGENTS_INSTALLED (in $CLAUDE_AGENTS_DIR)"
    echo
    log_info "SDD system is now ready to use!"
    log_info "Try: /init_greenfield your-project-name"
}

# BEHAVIOR 4: Error handling - comprehensive error handling following bundle_security.md
handle_error() {
    local exit_code=$?
    local line_number=$1
    
    log_error "Installation failed at line $line_number (exit code: $exit_code)"
    log_error "Installation may be incomplete. Please check error messages above."
    
    # Suggest recovery steps
    echo
    log_info "Recovery suggestions:"
    echo "  1. Check file permissions in target directories"
    echo "  2. Ensure sufficient disk space is available"
    echo "  3. Verify source files exist in: $SCRIPT_DIR"
    echo "  4. Check if directories are read-only"
    
    exit $exit_code
}

# Set up error handling - following bundle_security.md patterns
trap 'handle_error $LINENO' ERR

# Main installation function - following bundle_code_context.md patterns  
main() {
    log_info "Starting SDD system installation..."
    log_info "Script location: $SCRIPT_DIR"
    
    # Validate source directories exist before starting
    local missing_sources=0
    
    if [ ! -d "$TEMPLATES_SOURCE" ]; then
        log_error "Templates source not found: $TEMPLATES_SOURCE"
        ((missing_sources++))
    fi
    
    if [ ! -d "$COMMANDS_SOURCE" ]; then
        log_error "Commands source not found: $COMMANDS_SOURCE"  
        ((missing_sources++))
    fi
    
    if [ "$missing_sources" -gt 0 ]; then
        log_error "Missing source directories. Installation cannot proceed."
        exit 10
    fi
    
    # Perform installation steps
    install_templates || { log_error "Template installation failed"; exit 1; }
    install_commands || { log_error "Commands installation failed"; exit 1; }
    install_agents || { log_error "Agents installation failed"; exit 1; }
    
    # Validate installation
    verify_installation || { log_error "Installation verification failed"; exit 13; }
    
    log_info "SDD system installation completed successfully!"
    show_installation_summary
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi