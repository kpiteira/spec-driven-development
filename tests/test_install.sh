#!/bin/bash
# Test suite for SDD installation script
# Following TDD principles - tests written first, then implementation

set -euo pipefail

# Test framework setup
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TEST_DIR="/tmp/sdd_install_test_$$"
readonly INSTALL_SCRIPT="$SCRIPT_DIR/../install.sh"

# Color codes for test output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Test counters
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Test framework functions
log_test_start() {
    echo -e "${BLUE}[TEST]${NC} $*"
    ((TESTS_TOTAL++))
}

log_test_pass() {
    echo -e "${GREEN}[PASS]${NC} $*"
    ((TESTS_PASSED++))
}

log_test_fail() {
    echo -e "${RED}[FAIL]${NC} $*"
    ((TESTS_FAILED++))
}

log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Test environment setup
setup_test_environment() {
    log_info "Setting up test environment in $TEST_DIR"
    
    # Create clean test directory
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR"
    
    # Create mock home directory structure
    export TEST_HOME="$TEST_DIR/home"
    mkdir -p "$TEST_HOME"
    
    # Create mock repository structure with source files
    export TEST_REPO="$TEST_DIR/repo"
    mkdir -p "$TEST_REPO/.claude/commands"
    mkdir -p "$TEST_REPO/.claude/agents"
    mkdir -p "$TEST_REPO/specs/templates"
    
    # Create mock source files
    create_mock_templates
    create_mock_commands
    create_mock_agents
    
    log_info "Test environment setup complete"
}

create_mock_templates() {
    # Create mock template files
    cat > "$TEST_REPO/specs/templates/0_Project_Vision_Template.md" << 'EOF'
---
template: true
type: project-vision
---

# Project Vision Template

This is a mock template file for testing.
EOF

    cat > "$TEST_REPO/specs/templates/1_Product_Requirements_Template.md" << 'EOF'
---
template: true
type: product-requirements
---

# Product Requirements Template

This is a mock template file for testing.
EOF

    cat > "$TEST_REPO/specs/templates/4_Milestone_Plan_Template.md" << 'EOF'
---
template: true
type: milestone-plan
---

# Milestone Plan Template

This is a mock template file for testing.
EOF
}

create_mock_commands() {
    # Create mock command files
    cat > "$TEST_REPO/.claude/commands/init_greenfield.md" << 'EOF'
---
description: "Mock init_greenfield command for testing"
argument-hint: "[project-name]"
allowed-tools: ["Write", "Read", "LS", "Task"]
model: claude-opus-4-1-20250805
---

# Mock Greenfield Command

This is a mock command file for testing.
EOF

    cat > "$TEST_REPO/.claude/commands/plan_milestone.md" << 'EOF'
---
description: "Mock plan_milestone command for testing"  
argument-hint: "[milestone-name]"
allowed-tools: ["Write", "Read", "LS", "Task"]
model: claude-opus-4-1-20250805
---

# Mock Milestone Planning Command

This is a mock command file for testing.
EOF
}

create_mock_agents() {
    # Create mock agent files
    cat > "$TEST_REPO/.claude/agents/requirements-specialist.md" << 'EOF'
---
name: requirements-specialist
description: "Mock requirements specialist for testing"
tools: Read, Write, WebSearch, WebFetch
model: claude-opus-4-1-20250805
---

# Mock Requirements Specialist

This is a mock agent file for testing.
EOF
}

# Test cleanup
cleanup_test_environment() {
    log_info "Cleaning up test environment"
    rm -rf "$TEST_DIR"
}

# BEHAVIOR 1: Global Template Installation Tests
test_template_directory_creation() {
    log_test_start "Template directory creation"
    
    # Run installation script from test repository
    cd "$TEST_REPO"
    if bash "$INSTALL_SCRIPT" > /dev/null 2>&1; then
        local expected_dir="$TEST_HOME/.sdd/templates"
        if [ -d "$expected_dir" ]; then
            log_test_pass "Template directory created at $expected_dir"
        else
            log_test_fail "Template directory not found at $expected_dir"
        fi
    else
        log_test_fail "Installation script failed to run"
    fi
}

test_template_files_copied() {
    log_test_start "Template files copying"
    
    local templates_dir="$TEST_HOME/.sdd/templates"
    local expected_files=(
        "0_Project_Vision_Template.md"
        "1_Product_Requirements_Template.md" 
        "4_Milestone_Plan_Template.md"
    )
    
    local all_found=true
    for template in "${expected_files[@]}"; do
        if [ ! -f "$templates_dir/$template" ]; then
            log_test_fail "Template file not found: $template"
            all_found=false
        fi
    done
    
    if [ "$all_found" = true ]; then
        log_test_pass "All template files copied successfully"
    fi
}

test_template_backup_functionality() {
    log_test_start "Template backup functionality"
    
    # Create existing template to test backup
    local templates_dir="$TEST_HOME/.sdd/templates"
    mkdir -p "$templates_dir"
    echo "existing content" > "$templates_dir/0_Project_Vision_Template.md"
    
    # Run installation (will fail until implemented)
    # Should create backup of existing file
    
    if ls "$templates_dir"/0_Project_Vision_Template.md.backup.* 1> /dev/null 2>&1; then
        log_test_pass "Backup file created for existing template"
    else
        log_test_fail "No backup file created for existing template"
    fi
}

# BEHAVIOR 2: Claude Code Commands Installation Tests
test_commands_directory_creation() {
    log_test_start "Commands directory creation"
    
    local expected_dir="$TEST_REPO/.claude/commands"
    
    if [ -d "$expected_dir" ]; then
        log_test_pass "Commands directory exists at $expected_dir"
    else
        log_test_fail "Commands directory not found at $expected_dir"
    fi
}

test_command_files_copied() {
    log_test_start "Command files copying"
    
    local commands_dir="$TEST_REPO/.claude/commands"
    local expected_files=(
        "init_greenfield.md"
        "plan_milestone.md"
    )
    
    local all_found=true
    for command in "${expected_files[@]}"; do
        if [ ! -f "$commands_dir/$command" ]; then
            log_test_fail "Command file not found: $command"
            all_found=false
        fi
    done
    
    if [ "$all_found" = true ]; then
        log_test_pass "All command files present (pre-existing for test)"
    fi
}

# BEHAVIOR 3: Installation Validation Tests
test_installation_verification() {
    log_test_start "Installation verification"
    
    # Test template verification
    local templates_count
    templates_count=$(find "$TEST_HOME/.sdd/templates" -name "*.md" 2>/dev/null | wc -l || echo 0)
    
    if [ "$templates_count" -gt 0 ]; then
        log_test_pass "Template files verification passed ($templates_count files)"
    else
        log_test_fail "No template files found for verification"
    fi
}

test_command_file_validation() {
    log_test_start "Command file validation"
    
    local commands_dir="$TEST_REPO/.claude/commands"
    local valid_files=0
    
    for cmd_file in "$commands_dir"/*.md; do
        if [ -f "$cmd_file" ]; then
            # Check for required YAML frontmatter
            if head -1 "$cmd_file" | grep -q "^---$" && grep -q "^description:" "$cmd_file"; then
                ((valid_files++))
            fi
        fi
    done
    
    if [ "$valid_files" -gt 0 ]; then
        log_test_pass "Command file validation passed ($valid_files valid files)"
    else
        log_test_fail "No valid command files found"
    fi
}

# BEHAVIOR 4: Error Handling and Recovery Tests
test_permission_error_handling() {
    log_test_start "Permission error handling"
    
    # Create read-only directory to test permission handling
    local readonly_dir="$TEST_DIR/readonly"
    mkdir -p "$readonly_dir"
    chmod 444 "$readonly_dir"
    
    # Installation should handle permission errors gracefully
    # This test will pass when proper error handling is implemented
    
    log_test_fail "Permission error handling not yet implemented"
}

test_partial_installation_recovery() {
    log_test_start "Partial installation recovery"
    
    # Test recovery from interrupted installation
    # This test will pass when recovery functionality is implemented
    
    log_test_fail "Partial installation recovery not yet implemented"
}

# Main test runner
run_all_tests() {
    log_info "Starting SDD Installation Script Test Suite"
    
    setup_test_environment
    
    # Behavior 1: Global Template Installation
    log_info "Running Behavior 1 tests: Global Template Installation"
    test_template_directory_creation
    test_template_files_copied  
    test_template_backup_functionality
    
    # Behavior 2: Claude Code Commands Installation
    log_info "Running Behavior 2 tests: Claude Code Commands Installation"
    test_commands_directory_creation
    test_command_files_copied
    
    # Behavior 3: Installation Validation
    log_info "Running Behavior 3 tests: Installation Validation"
    test_installation_verification
    test_command_file_validation
    
    # Behavior 4: Error Handling and Recovery
    log_info "Running Behavior 4 tests: Error Handling and Recovery"
    test_permission_error_handling
    test_partial_installation_recovery
    
    cleanup_test_environment
    
    # Test summary
    echo
    log_info "Test Results Summary:"
    echo "  Total tests: $TESTS_TOTAL"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    
    if [ "$TESTS_FAILED" -eq 0 ]; then
        log_info "All tests passed!"
        exit 0
    else
        log_error "Some tests failed!"
        exit 1
    fi
}

# Check if install.sh exists
if [ ! -f "$INSTALL_SCRIPT" ]; then
    log_warn "install.sh not found - tests will show expected failures until implementation"
fi

# Run tests
run_all_tests