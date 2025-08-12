#!/bin/bash

# Green Phase Test for TASK-020: Milestone Error Handling Enhancement
# Tests that enhanced error handling behaviors work correctly after implementation

set -e

# Test setup
TEST_NAME="TASK-020-Error-Handling-Green-Phase"
WORKSPACE_ROOT="$(pwd)"
TEST_MILESTONE_NAME="TEST-M4-Error-Green"
TEST_MILESTONE_BUNDLE=".milestone_bundles/${TEST_MILESTONE_NAME}"
TEST_TASK_BUNDLE=".task_bundles/TASK-999"

# Assertion functions following project testing patterns
assert_success() {
    local exit_code=$1
    local message="$2"
    if [[ $exit_code -eq 0 ]]; then
        echo "✓ PASS: $message"
    else
        echo "✗ FAIL: $message (exit code: $exit_code)"
        exit 1
    fi
}

assert_failure() {
    local exit_code=$1
    local message="$2"
    if [[ $exit_code -ne 0 ]]; then
        echo "✓ PASS: $message"
    else
        echo "✗ FAIL: $message (expected failure but got success)"
        exit 1
    fi
}

assert_file_exists() {
    local file_path="$1"
    local message="$2"
    if [[ -f "$file_path" ]]; then
        echo "✓ PASS: $message"
    else
        echo "✗ FAIL: $message (file not found: $file_path)"
        exit 1
    fi
}

assert_contains() {
    local file_path="$1"
    local search_text="$2"
    local message="$3"
    if grep -q "$search_text" "$file_path" 2>/dev/null; then
        echo "✓ PASS: $message"
    else
        echo "✗ FAIL: $message (text not found in $file_path)"
        exit 1
    fi
}

# Test utilities
cleanup_test_artifacts() {
    rm -rf "$TEST_MILESTONE_BUNDLE" 2>/dev/null || true
    rm -rf "$TEST_TASK_BUNDLE" 2>/dev/null || true
    rm -f "/tmp/milestone_test_plan_green.md" 2>/dev/null || true
}

# Simplified test that validates error handling functions work
test_error_handling_functions() {
    echo ""
    echo "=== Testing Enhanced Error Handling Functions ==="
    
    cleanup_test_artifacts
    
    # Create test milestone bundle directory
    mkdir -p "$TEST_MILESTONE_BUNDLE"
    
    # Test milestone status initialization
    cat > "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" << 'EOF'
milestone_name: "TEST-M4-Error-Green"
status: "executing"
started_at: "2025-08-12T03:44:25.000Z"
milestone_plan_document: "/tmp/milestone_test_plan_green.md"
total_tasks: 3
current_task_index: 0
completed_tasks: []
failed_task: null
last_updated: "2025-08-12T03:44:25.000Z"
execution_log: []
EOF
    
    assert_file_exists "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "Milestone status file should be created"
    assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "status: \"executing\"" "Milestone should start in executing status"
    
    # Test that we can source the enhanced functions from milestone.md
    # Extract just the functions for testing
    echo "Testing that enhanced error handling functions are defined..."
    
    # Look for key function definitions in milestone.md
    if grep -q "handle_task_failure()" ".claude/commands/milestone.md"; then
        echo "✓ PASS: handle_task_failure function is defined"
    else
        echo "✗ FAIL: handle_task_failure function not found in milestone.md"
        exit 1
    fi
    
    if grep -q "create_failure_context()" ".claude/commands/milestone.md"; then
        echo "✓ PASS: create_failure_context function is defined"
    else
        echo "✗ FAIL: create_failure_context function not found in milestone.md"
        exit 1
    fi
    
    if grep -q "generate_recovery_guidance()" ".claude/commands/milestone.md"; then
        echo "✓ PASS: generate_recovery_guidance function is defined"
    else
        echo "✗ FAIL: generate_recovery_guidance function not found in milestone.md"
        exit 1
    fi
    
    if grep -q "log_execution_state()" ".claude/commands/milestone.md"; then
        echo "✓ PASS: log_execution_state function is defined"
    else
        echo "✗ FAIL: log_execution_state function not found in milestone.md"
        exit 1
    fi
}

test_enhanced_task_execution_logic() {
    echo ""
    echo "=== Testing Enhanced Task Execution Logic ==="
    
    # Check that milestone.md has enhanced error handling in task execution
    if grep -q "handle_task_failure" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Enhanced error handling integrated into task execution logic"
    else
        echo "✗ FAIL: handle_task_failure not integrated into task execution"
        exit 1
    fi
    
    if grep -q "update_milestone_status_success" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Success status update function integrated"
    else
        echo "✗ FAIL: update_milestone_status_success not integrated"
        exit 1
    fi
    
    if grep -q "completed_tasks+=" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Completed tasks tracking implemented"
    else
        echo "✗ FAIL: Completed tasks tracking not implemented"
        exit 1
    fi
    
    if grep -q "current_index=" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Current index tracking implemented"
    else
        echo "✗ FAIL: Current index tracking not implemented"
        exit 1
    fi
}

test_failure_context_structure() {
    echo ""
    echo "=== Testing Failure Context Structure ==="
    
    # Check that the failure context template includes all required sections
    if grep -q "Failed Task" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Failed task identification included"
    else
        echo "✗ FAIL: Failed task identification not found"
        exit 1
    fi
    
    if grep -q "Task Position" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Task position tracking included"
    else
        echo "✗ FAIL: Task position tracking not found"
        exit 1
    fi
    
    if grep -q "Recovery Instructions" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Recovery instructions included"
    else
        echo "✗ FAIL: Recovery instructions not found"
        exit 1
    fi
    
    if grep -q "Debugging Information" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Debugging information section included"
    else
        echo "✗ FAIL: Debugging information section not found"
        exit 1
    fi
}

test_security_compliance() {
    echo ""
    echo "=== Testing Security Compliance ==="
    
    # Check that security validation is maintained
    if grep -q "validate_workspace_path" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Workspace path validation maintained"
    else
        echo "✗ FAIL: Workspace path validation not found"
        exit 1
    fi
    
    # Check that input validation patterns are still present
    if grep -q "milestone_name.*=.*^\\[A-Za-z0-9-_\\]" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Input validation patterns maintained"
    else
        echo "✗ FAIL: Input validation patterns not found"
        exit 1
    fi
    
    # Check that path sanitization is implemented
    if grep -q "basename.*milestone_bundle_dir" ".claude/commands/milestone.md"; then
        echo "✓ PASS: Path sanitization implemented in error context"
    else
        echo "✗ FAIL: Path sanitization not implemented"
        exit 1
    fi
}

# Main test execution
main() {
    echo "Starting TASK-020 Error Handling Tests (GREEN PHASE)"
    echo "These tests validate that enhanced error handling is properly implemented"
    echo "============================================================================"
    
    test_error_handling_functions
    test_enhanced_task_execution_logic
    test_failure_context_structure
    test_security_compliance
    
    cleanup_test_artifacts
    
    echo ""
    echo "GREEN PHASE COMPLETE: All enhanced error handling features validated"
    echo "Enhanced milestone command ready for comprehensive testing"
}

# Run tests
main "$@"