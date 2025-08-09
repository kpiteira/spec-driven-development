#!/bin/bash
# End-to-End SDD System Test
#
# This script tests the complete user journey from installation to first usage,
# simulating a new user's experience with the SDD system.

set -euo pipefail

# Test configuration
readonly E2E_TEST_DIR="/tmp/sdd-e2e-test-$$"
readonly TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR="$(dirname "$TESTS_DIR")"
readonly TEST_PROJECT_NAME="E2E Test Portfolio"

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Test results tracking
declare -i TESTS_PASSED=0
declare -i TESTS_FAILED=0
declare -a TEST_LOG=()

# Logging functions
log_info() { echo -e "${GREEN}[INFO]${NC} $*"; TEST_LOG+=("INFO: $*"); }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; TEST_LOG+=("WARN: $*"); }
log_error() { echo -e "${RED}[ERROR]${NC} $*"; TEST_LOG+=("ERROR: $*"); }
log_debug() { echo -e "${BLUE}[DEBUG]${NC} $*"; TEST_LOG+=("DEBUG: $*"); }

# Test assertion functions
assert_success() {
    local test_name="$1"
    local exit_code="${2:-0}"
    
    if [[ $exit_code -eq 0 ]]; then
        log_info "✓ $test_name"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "✗ $test_name (exit code: $exit_code)"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="$2"
    
    if [[ -f "$file" ]]; then
        log_info "✓ $test_name: File exists"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "✗ $test_name: File missing - $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local test_name="$2"
    
    if [[ -d "$dir" ]]; then
        log_info "✓ $test_name: Directory exists"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "✗ $test_name: Directory missing - $dir"
        ((TESTS_FAILED++))
        return 1
    fi
}

assert_contains() {
    local file="$1"
    local pattern="$2"
    local test_name="$3"
    
    if [[ -f "$file" ]] && grep -q "$pattern" "$file"; then
        log_info "✓ $test_name: Pattern found"
        ((TESTS_PASSED++))
        return 0
    else
        log_error "✗ $test_name: Pattern not found - $pattern in $file"
        ((TESTS_FAILED++))
        return 1
    fi
}

# Setup test environment
setup_test_environment() {
    log_info "Setting up end-to-end test environment..."
    
    # Clean up any previous test runs
    if [[ -d "$E2E_TEST_DIR" ]]; then
        rm -rf "$E2E_TEST_DIR"
    fi
    
    # Create test directory structure
    mkdir -p "$E2E_TEST_DIR"/{installation,project}
    
    log_debug "Test environment created at: $E2E_TEST_DIR"
}

# Test Phase 1: Fresh Installation
test_fresh_installation() {
    log_info "=== Phase 1: Testing Fresh Installation ==="
    
    # Set TEST_HOME to isolate installation
    export TEST_HOME="$E2E_TEST_DIR/installation"
    
    # Copy repository for testing
    cp -r "$SCRIPT_DIR/." "$E2E_TEST_DIR/installation/sdd-repo"
    cd "$E2E_TEST_DIR/installation/sdd-repo"
    
    # Test local installation script
    log_info "Testing local installation script..."
    if ./install.sh > "$E2E_TEST_DIR/installation.log" 2>&1; then
        assert_success "Local installation script execution"
    else
        assert_success "Local installation script execution" 1
        log_error "Installation log:"
        tail -20 "$E2E_TEST_DIR/installation.log"
        return 1
    fi
    
    # Verify installation results
    assert_dir_exists "$E2E_TEST_DIR/installation/.sdd/templates" "Templates directory creation"
    assert_dir_exists "$E2E_TEST_DIR/installation/.claude/commands" "Commands directory creation"
    assert_dir_exists "$E2E_TEST_DIR/installation/.claude/agents" "Agents directory creation"
    
    # Verify template files
    local template_count
    template_count=$(find "$E2E_TEST_DIR/installation/.sdd/templates" -name "*.md" | wc -l)
    if [[ $template_count -eq 6 ]]; then
        assert_success "Template files count (expected: 6, found: $template_count)"
    else
        assert_success "Template files count (expected: 6, found: $template_count)" 1
    fi
    
    # Verify command files
    local command_count
    command_count=$(find "$E2E_TEST_DIR/installation/.claude/commands" -name "*.md" | grep -v temp | wc -l)
    if [[ $command_count -ge 2 ]]; then
        assert_success "Command files count (expected: >=2, found: $command_count)"
    else
        assert_success "Command files count (expected: >=2, found: $command_count)" 1
    fi
    
    # Verify specific critical files
    assert_file_exists "$E2E_TEST_DIR/installation/.sdd/templates/0_Project_Vision_Template.md" "Project Vision Template"
    assert_file_exists "$E2E_TEST_DIR/installation/.claude/commands/init_greenfield.md" "Init Greenfield Command"
    
    cd "$SCRIPT_DIR"
    unset TEST_HOME
}

# Test Phase 2: Project Initialization Simulation
test_project_initialization() {
    log_info "=== Phase 2: Testing Project Initialization ==="
    
    # Create a test project directory
    local project_dir="$E2E_TEST_DIR/project/my-portfolio"
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Simulate the init_greenfield command by copying templates manually
    # In a real scenario, this would be done by Claude Code
    log_info "Simulating /init_greenfield command execution..."
    
    # Create specs directory structure
    mkdir -p specs/{milestones,tasks}
    
    # Copy and customize templates (simulating what init_greenfield would do)
    cp "$E2E_TEST_DIR/installation/.sdd/templates/0_Project_Vision_Template.md" "specs/0_Project_Vision.md"
    cp "$E2E_TEST_DIR/installation/.sdd/templates/1_Product_Requirements_Template.md" "specs/1_Product_Requirements.md"
    cp "$E2E_TEST_DIR/installation/.sdd/templates/2_Architecture_Template.md" "specs/2_Architecture.md"
    cp "$E2E_TEST_DIR/installation/.sdd/templates/3_Roadmap_Template.md" "specs/3_Roadmap.md"
    
    # Customize the project vision (simulate user input)
    cat > "specs/0_Project_Vision.md" << 'EOF'
---
id: "portfolio-vision"
title: "Personal Portfolio Website - Project Vision"
created_date: "2024-01-09"
status: "active"
---

# Project Vision: Personal Portfolio Website

## 1. Mission Statement
To create a professional, modern portfolio website that effectively showcases my software development skills and projects to potential employers and collaborators.

## 2. Problem Statement
Currently, I lack a centralized, professional online presence to showcase my work. Potential employers have difficulty understanding my capabilities and project experience without a cohesive presentation of my skills.

## 3. Target Audience
**Primary Users:**
- Hiring managers and technical recruiters
- Fellow developers and potential collaborators
- Clients seeking development services

## 4. High-Level Goals & Success Metrics
| Goal | Metric | Timeframe |
|------|--------|-----------|
| Professional online presence | Website live and accessible | 1 month |
| Showcase technical skills | Display 5+ completed projects | 2 months |
| Attract opportunities | Receive 3+ inquiries per month | 3 months |
EOF
    
    # Verify project structure creation
    assert_dir_exists "$project_dir/specs" "Project specs directory"
    assert_dir_exists "$project_dir/specs/milestones" "Milestones directory"
    assert_dir_exists "$project_dir/specs/tasks" "Tasks directory"
    
    # Verify specification files
    assert_file_exists "$project_dir/specs/0_Project_Vision.md" "Project Vision document"
    assert_file_exists "$project_dir/specs/1_Product_Requirements.md" "Product Requirements document"
    assert_file_exists "$project_dir/specs/2_Architecture.md" "Architecture document"
    assert_file_exists "$project_dir/specs/3_Roadmap.md" "Roadmap document"
    
    # Verify document content customization
    assert_contains "$project_dir/specs/0_Project_Vision.md" "Personal Portfolio Website" "Vision customization"
    assert_contains "$project_dir/specs/0_Project_Vision.md" "professional online presence" "Vision content"
    
    cd "$SCRIPT_DIR"
}

# Test Phase 3: Document Structure and Quality
test_document_quality() {
    log_info "=== Phase 3: Testing Document Structure and Quality ==="
    
    local project_dir="$E2E_TEST_DIR/project/my-portfolio"
    
    # Test YAML frontmatter in templates
    if head -10 "$E2E_TEST_DIR/installation/.sdd/templates/0_Project_Vision_Template.md" | grep -q "^version:"; then
        assert_success "Template version frontmatter"
    else
        assert_success "Template version frontmatter" 1
    fi
    
    # Test document structure
    if grep -q "## 1\. Mission Statement" "$project_dir/specs/0_Project_Vision.md"; then
        assert_success "Vision document structure"
    else
        assert_success "Vision document structure" 1
    fi
    
    # Test that templates are properly formatted Markdown
    if head -1 "$E2E_TEST_DIR/installation/.sdd/templates/0_Project_Vision_Template.md" | grep -q "^---$"; then
        assert_success "Template Markdown format"
    else
        assert_success "Template Markdown format" 1
    fi
    
    # Test command file structure
    if grep -q "^description:" "$E2E_TEST_DIR/installation/.claude/commands/init_greenfield.md"; then
        assert_success "Command file frontmatter"
    else
        assert_success "Command file frontmatter" 1
    fi
}

# Test Phase 4: Milestone Planning Simulation
test_milestone_planning() {
    log_info "=== Phase 4: Testing Milestone Planning Simulation ==="
    
    local project_dir="$E2E_TEST_DIR/project/my-portfolio"
    cd "$project_dir"
    
    # Simulate milestone planning (what plan_milestone command would do)
    log_info "Simulating /plan_milestone command..."
    
    # Create a milestone plan
    mkdir -p specs/milestones
    cat > "specs/milestones/M1_Foundation.md" << 'EOF'
---
id: "M1-Foundation"
title: "M1: Portfolio Foundation"
milestone_id: "M1-Foundation"
status: "planned"
created_date: "2024-01-09"
---

# Milestone Plan: M1 - Portfolio Foundation

## 1. Milestone Goals & Success Criteria
Set up the basic portfolio website structure with responsive design and navigation.

**Success Criteria:**
- [x] Project setup and build system configured
- [x] Responsive HTML/CSS framework integrated
- [x] Basic navigation and layout implemented
- [x] Contact form functional

## 2. Task Breakdown
- **TASK-001**: Project setup and tooling configuration
- **TASK-002**: HTML structure and responsive design
- **TASK-003**: Contact form implementation
- **TASK-004**: Basic styling and branding

## 3. Dependencies and Constraints
**Dependencies:** None (foundational milestone)
**Constraints:** Must be mobile-responsive from the start
EOF
    
    # Create task blueprints
    mkdir -p specs/tasks
    cat > "specs/tasks/TASK-001_Project_Setup.md" << 'EOF'
---
id: "TASK-001"
title: "Project setup and tooling configuration"
milestone_id: "M1-Foundation"
status: "pending"
created_date: "2024-01-09"
---

# Task Blueprint: TASK-001 - Project Setup

## 1. Task Overview & Goal
Configure the development environment and build system for the portfolio website.

## 2. The Contract: Requirements & Test Cases
- Build system (Vite/Webpack) configured and working
- Development server runs on localhost
- Basic HTML template structure created
- Asset pipeline configured for CSS and images

## 3. Verification
- `npm run dev` starts development server
- `npm run build` creates production bundle
- Basic index.html loads without errors
EOF
    
    # Verify milestone and task creation
    assert_file_exists "$project_dir/specs/milestones/M1_Foundation.md" "Milestone plan creation"
    assert_file_exists "$project_dir/specs/tasks/TASK-001_Project_Setup.md" "Task blueprint creation"
    
    # Verify milestone content structure
    assert_contains "$project_dir/specs/milestones/M1_Foundation.md" "Success Criteria" "Milestone success criteria"
    assert_contains "$project_dir/specs/milestones/M1_Foundation.md" "TASK-001" "Milestone task references"
    
    # Verify task blueprint structure
    assert_contains "$project_dir/specs/tasks/TASK-001_Project_Setup.md" "The Contract" "Task contract section"
    assert_contains "$project_dir/specs/tasks/TASK-001_Project_Setup.md" "Verification" "Task verification section"
    
    cd "$SCRIPT_DIR"
}

# Test Phase 5: Documentation Accessibility
test_documentation_accessibility() {
    log_info "=== Phase 5: Testing Documentation Accessibility ==="
    
    # Test that installation documentation exists and is readable
    assert_file_exists "$SCRIPT_DIR/INSTALLATION.md" "Installation documentation"
    assert_file_exists "$SCRIPT_DIR/GETTING_STARTED.md" "Getting started guide"
    assert_file_exists "$SCRIPT_DIR/TROUBLESHOOTING.md" "Troubleshooting guide"
    
    # Test documentation structure
    assert_contains "$SCRIPT_DIR/INSTALLATION.md" "## Table of Contents" "Installation TOC"
    assert_contains "$SCRIPT_DIR/INSTALLATION.md" "Prerequisites" "Installation prerequisites"
    assert_contains "$SCRIPT_DIR/INSTALLATION.md" "curl -sSL" "Curl installation method"
    
    assert_contains "$SCRIPT_DIR/GETTING_STARTED.md" "Your First Project" "Getting started workflow"
    assert_contains "$SCRIPT_DIR/GETTING_STARTED.md" "/init_greenfield" "Command examples"
    
    assert_contains "$SCRIPT_DIR/TROUBLESHOOTING.md" "Installation Issues" "Troubleshooting categories"
    assert_contains "$SCRIPT_DIR/TROUBLESHOOTING.md" "curl: command not found" "Common issues"
}

# Test Phase 6: Security Verification
test_security_practices() {
    log_info "=== Phase 6: Testing Security Practices ==="
    
    # Check that remote installer includes security warnings
    if [[ -f "$SCRIPT_DIR/remote-install.sh" ]]; then
        assert_file_exists "$SCRIPT_DIR/remote-install.sh" "Remote installer exists"
        assert_contains "$SCRIPT_DIR/remote-install.sh" "SECURITY NOTICE" "Security warning"
        assert_contains "$SCRIPT_DIR/remote-install.sh" "Continue with installation" "User consent"
        assert_contains "$SCRIPT_DIR/remote-install.sh" "shasum\\|sha256sum" "Checksum verification"
    else
        assert_success "Remote installer file check" 1
    fi
    
    # Check that installation scripts use secure practices
    assert_contains "$SCRIPT_DIR/install.sh" "set -euo pipefail" "Bash strict mode"
    assert_contains "$SCRIPT_DIR/install.sh" "validate_path" "Path validation"
    
    # Check that documentation includes security guidance
    assert_contains "$SCRIPT_DIR/INSTALLATION.md" "Security Considerations" "Security documentation"
    assert_contains "$SCRIPT_DIR/INSTALLATION.md" "Review scripts before execution" "Security best practices"
}

# Cleanup test environment
cleanup_test_environment() {
    log_info "Cleaning up test environment..."
    
    if [[ -d "$E2E_TEST_DIR" ]]; then
        rm -rf "$E2E_TEST_DIR"
        log_debug "Test directory removed: $E2E_TEST_DIR"
    fi
}

# Display test results and generate report
show_test_results() {
    echo
    echo "🧪 End-to-End Test Results"
    echo "========================="
    echo "  Tests passed: $TESTS_PASSED"
    echo "  Tests failed: $TESTS_FAILED"
    echo "  Total tests: $((TESTS_PASSED + TESTS_FAILED))"
    echo
    
    if [[ $TESTS_FAILED -gt 0 ]]; then
        echo "❌ Some tests failed. Check the log for details."
        echo
        echo "📋 Test Log Summary:"
        for log_entry in "${TEST_LOG[@]}"; do
            if [[ $log_entry =~ ^ERROR: ]]; then
                echo "  $log_entry"
            fi
        done
        echo
        return 1
    else
        echo "✅ All end-to-end tests passed!"
        echo
        echo "🎉 SDD System is ready for users!"
        echo
        return 0
    fi
}

# Generate detailed test report
generate_test_report() {
    local report_file="$SCRIPT_DIR/e2e-test-report.md"
    
    cat > "$report_file" << EOF
# SDD System End-to-End Test Report

**Test Date:** $(date)
**Test Environment:** $E2E_TEST_DIR
**Tests Passed:** $TESTS_PASSED
**Tests Failed:** $TESTS_FAILED

## Test Results Summary

### Phase 1: Fresh Installation
- Installation script execution
- Directory structure creation
- File count verification
- Critical file presence

### Phase 2: Project Initialization
- Project directory structure
- Specification document creation
- Template customization
- Content verification

### Phase 3: Document Quality
- YAML frontmatter validation
- Markdown structure verification
- Command file format checking

### Phase 4: Milestone Planning
- Milestone plan creation
- Task blueprint generation
- Document cross-references
- Content structure validation

### Phase 5: Documentation Accessibility
- Installation guide completeness
- Getting started workflow coverage
- Troubleshooting documentation

### Phase 6: Security Practices
- Security warning implementation
- User consent mechanisms
- Secure coding practices
- Documentation security guidance

## Detailed Test Log

EOF
    
    for log_entry in "${TEST_LOG[@]}"; do
        echo "- $log_entry" >> "$report_file"
    done
    
    echo >> "$report_file"
    echo "Report generated: $(date)" >> "$report_file"
    
    log_info "Detailed test report saved to: $report_file"
}

# Main test execution
main() {
    log_info "Starting SDD System End-to-End Tests..."
    
    setup_test_environment
    
    # Execute all test phases
    test_fresh_installation
    test_project_initialization
    test_document_quality
    test_milestone_planning
    test_documentation_accessibility
    test_security_practices
    
    cleanup_test_environment
    generate_test_report
    
    # Show results and exit appropriately
    if show_test_results; then
        log_info "End-to-end testing completed successfully!"
        exit 0
    else
        log_error "End-to-end testing failed - system may not be ready for users"
        exit 1
    fi
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi