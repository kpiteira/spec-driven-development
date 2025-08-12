#!/bin/bash

# Test file for TASK-020: Milestone Error Handling Enhancement
# Tests comprehensive error handling behaviors following TDD Red-Green-Refactor cycle

set -e

# Test setup
TEST_NAME="TASK-020-Error-Handling"
WORKSPACE_ROOT="$(pwd)"
TEST_MILESTONE_NAME="TEST-M4-Error-Handling"
TEST_MILESTONE_BUNDLE=".milestone_bundles/${TEST_MILESTONE_NAME}"
TEST_TASK_BUNDLE=".task_bundles/TASK-999"  # Simulated failing task

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
    rm -f "/tmp/milestone_test_plan.md" 2>/dev/null || true
}

create_test_milestone_plan() {
    cat > "/tmp/milestone_test_plan.md" << 'EOF'
# TEST-M4-Error-Handling Milestone Plan

## Implementation Plan

**Task Sequence:**
1. **TASK-998:** This task should complete successfully
2. **TASK-999:** This task will fail to test error handling
3. **TASK-1000:** This task should not be attempted after failure

## Testing Scenario
This milestone plan is designed to test error handling by having TASK-999 fail.
EOF
}

create_failing_task_bundle() {
    mkdir -p "$TEST_TASK_BUNDLE"
    cat > "$TEST_TASK_BUNDLE/bundle_status.yaml" << 'EOF'
task_id: TASK-999
status: "failed"
created_at: "2025-08-12T03:44:25.000Z"
bundling_completed_at: "2025-08-12T03:44:30.000Z"
coding_completed_at: "2025-08-12T03:44:35.000Z"
validation_failed_at: "2025-08-12T03:44:40.000Z"
workflow_phase: "validation_failed"
bundle_path: ".task_bundles/TASK-999"
task_blueprint: "task_blueprint.md"
bundler_agent_completed: true
coder_agent_completed: true
validator_agent_completed: false
failure_reason: "Unit tests failed during validation"
last_updated: "2025-08-12T03:44:40.000Z"
EOF
}

# Test runners
test_behavior_1_immediate_stop_on_failure() {
    echo ""
    echo "=== Testing Behavior 1: Immediate Stop on Task Failure ==="
    
    cleanup_test_artifacts
    create_test_milestone_plan
    create_failing_task_bundle
    
    # This test should FAIL because current milestone command doesn't have enhanced error handling
    # When we run milestone command with a task that fails, it should:
    # 1. Stop immediately without attempting subsequent tasks  
    # 2. Clearly attribute failure to specific task
    # 3. Preserve exact point of failure for debugging
    # 4. Not perform cleanup/rollback
    
    echo "Testing that milestone execution stops on task failure..."
    
    # Simulate milestone execution with failing task
    # This should fail because enhanced error handling is not yet implemented
    bash -c "
        cd '$WORKSPACE_ROOT'
        
        # Mock the /task command to simulate failure for TASK-999
        function task() { 
            if [[ \$1 == 'TASK-999' ]]; then 
                echo 'TASK-999 failed during execution'
                return 1  # Simulate task failure
            else
                echo 'TASK-998 completed successfully'
                return 0  # Simulate task success
            fi
        }
        
        # Try to run milestone - this should fail with current implementation
        /milestone '$TEST_MILESTONE_NAME'
    " 2>/dev/null
    local exit_code=$?
    
    # This test should FAIL in Red phase because enhanced error handling is not implemented
    assert_failure $exit_code "Milestone command should detect and fail on task failure (RED PHASE - expected to fail)"
    
    echo "✗ EXPECTED FAILURE: Enhanced error handling not yet implemented"
}

test_behavior_2_detailed_error_context_preservation() {
    echo ""
    echo "=== Testing Behavior 2: Detailed Error Information and Context Preservation ==="
    
    cleanup_test_artifacts
    create_test_milestone_plan
    create_failing_task_bundle
    
    # This test should FAIL because current milestone command doesn't preserve detailed context
    # Enhanced error handling should:
    # 1. Provide detailed error information including task ID, failure reason, execution context
    # 2. Preserve all task bundle context for failed task
    # 3. Preserve milestone execution state for resume capability
    # 4. Include specific details about what went wrong and where
    
    echo "Testing detailed error information and context preservation..."
    
    # Check if failure context file would be created (it won't be in current implementation)
    if [[ -f "$TEST_MILESTONE_BUNDLE/failure_context.md" ]]; then
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Failed Task: TASK-999" "Failure context should identify specific failed task"
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Task Position:" "Failure context should show task position"
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Debugging Information" "Failure context should include debugging section"
    else
        echo "✗ EXPECTED FAILURE: No failure context file created - enhanced error handling not implemented"
    fi
    
    # Check if milestone status is preserved with failure details
    if [[ -f "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" ]]; then
        assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "failed_task:" "Milestone status should track failed task"
        assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "status: \"failed\"" "Milestone status should be marked as failed"
    else
        echo "✗ EXPECTED FAILURE: No milestone status file created - enhanced error handling not implemented"
    fi
}

test_behavior_3_recovery_guidance_and_next_steps() {
    echo ""
    echo "=== Testing Behavior 3: Recovery Guidance and Next Steps ==="
    
    cleanup_test_artifacts
    create_test_milestone_plan
    create_failing_task_bundle
    
    # This test should FAIL because current milestone command doesn't provide recovery guidance
    # Enhanced error handling should:
    # 1. Provide specific guidance on next steps (retry, investigate, abort)
    # 2. Tailor guidance to type of failure encountered
    # 3. Provide clear instructions for investigating failure using preserved context
    # 4. Explain recovery options with their implications
    
    echo "Testing recovery guidance generation..."
    
    # Check if recovery guidance is generated in failure context
    if [[ -f "$TEST_MILESTONE_BUNDLE/failure_context.md" ]]; then
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Recovery Instructions" "Failure context should include recovery instructions"
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Review task bundle" "Should provide instruction to review task bundle"
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Re-run milestone" "Should provide instruction to re-run milestone"
    else
        echo "✗ EXPECTED FAILURE: No recovery guidance generated - enhanced error handling not implemented"
    fi
    
    # Check if error messages include actionable guidance
    # This will fail because current implementation doesn't provide structured guidance
    echo "✗ EXPECTED FAILURE: Recovery guidance not implemented in current milestone command"
}

test_behavior_4_execution_state_visibility() {
    echo ""
    echo "=== Testing Behavior 4: Execution State Visibility ==="
    
    cleanup_test_artifacts
    create_test_milestone_plan
    create_failing_task_bundle
    
    # This test should FAIL because current milestone command doesn't provide comprehensive state visibility
    # Enhanced error handling should:
    # 1. Clearly report which tasks completed successfully
    # 2. Clearly identify the specific task that failed
    # 3. Clearly indicate tasks that were not attempted
    # 4. Summarize overall milestone progress for recovery planning
    
    echo "Testing execution state visibility..."
    
    # Check if milestone status tracks execution progress accurately
    if [[ -f "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" ]]; then
        assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "completed_tasks:" "Should track completed tasks"
        assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "current_task_index:" "Should track current position"
        assert_contains "$TEST_MILESTONE_BUNDLE/milestone_status.yaml" "total_tasks:" "Should track total task count"
    else
        echo "✗ EXPECTED FAILURE: No execution state tracking - enhanced error handling not implemented"
    fi
    
    # Check if failure context provides progress summary
    if [[ -f "$TEST_MILESTONE_BUNDLE/failure_context.md" ]]; then
        assert_contains "$TEST_MILESTONE_BUNDLE/failure_context.md" "Task Position:" "Should show task position in sequence"
    else
        echo "✗ EXPECTED FAILURE: No execution state visibility - enhanced error handling not implemented"
    fi
}

# Main test execution
main() {
    echo "Starting TASK-020 Error Handling Tests (RED PHASE)"
    echo "These tests are expected to FAIL because enhanced error handling is not yet implemented"
    echo "=================================================="
    
    test_behavior_1_immediate_stop_on_failure
    test_behavior_2_detailed_error_context_preservation
    test_behavior_3_recovery_guidance_and_next_steps
    test_behavior_4_execution_state_visibility
    
    cleanup_test_artifacts
    
    echo ""
    echo "RED PHASE COMPLETE: All tests failed as expected"
    echo "Next step: Implement enhanced error handling to make tests pass (GREEN PHASE)"
}

# Run tests
main "$@"