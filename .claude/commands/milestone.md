---
description: "Orchestrate sequential milestone execution using natural language comprehension of milestone plan documents"
argument-hint: "[milestone-name]"
allowed-tools: ["Read", "Write", "LS", "Task", "Bash"]
model: claude-sonnet-4-20250514
---

# Milestone Command - Sequential Task Execution Orchestrator

You orchestrate the sequential execution of all tasks within a specified milestone plan, enabling Human Architects to execute complete milestones autonomously through natural language comprehension of milestone plan documents.

## Core Mission: Milestone Automation

Transform milestone plans into executed reality through:
- **Natural Language Comprehension** of milestone plan documents to identify task sequences
- **Sequential Task Execution** using proven `/task` command infrastructure from M2
- **Progress Reporting** with clear task position and completion status  
- **Failure Handling** with immediate stop and context preservation for debugging

## Your Orchestration Mission

1. **Comprehend the milestone plan** using natural language understanding
2. **Extract task sequences** in the order they appear in the plan
3. **Execute tasks sequentially** using existing `/task TASK-ID` infrastructure
4. **Report progress** clearly throughout execution
5. **Handle failures** gracefully with immediate stop and clear error reporting

You are NOT implementing individual tasks - you're orchestrating their sequential execution using proven infrastructure.

## Phase 1: Milestone Plan Comprehension & Validation

### 1.1 Validate Milestone Name
- Validate format using security pattern: `\^\\[A-Za-z0-9-_\\]\+\$`
- Reject names containing special characters, paths, or shell metacharacters
- Enforce maximum length (50 characters) to prevent buffer issues
- Exit with clear error if invalid input detected

### 1.2 Discover and Read Milestone Plan Document
Search standard locations for milestone plan documents:
- `project_sdd_on_claude/[number]_[milestone-name]_Milestone_Plan.md`
- `project_sdd_on_claude/[milestone-name]_Milestone_Plan.md` 
- `specs/milestones/[milestone-name].md`
- `specs/[milestone-name]_Milestone_Plan.md`

Use pattern matching to find documents containing the milestone name:
```bash
# Example search pattern
milestone_doc=""
for location in "project_sdd_on_claude" "specs/milestones" "specs"; do
    if found_file=$(find "$location" -name "*${milestone_name}*Milestone_Plan.md" 2>/dev/null | head -1); then
        if [[ -f "$found_file" ]]; then
            milestone_doc="$found_file"
            break
        fi
    fi
done
```

### 1.3 Extract Task Sequences Through Natural Language Comprehension
Read the milestone plan document and identify all TASK-XXX identifiers by:

1. **Understanding Implementation Plan Sections**: Look for sections titled "Implementation Plan", "Task Sequence", "Task Breakdown", or similar
2. **Identifying Vertical Slices**: Understand how tasks are organized in slices with dependencies
3. **Extracting Task Order**: Capture TASK-XXX identifiers in the order they appear in the document
4. **Validating Task Format**: Ensure all extracted identifiers match pattern `^TASK-[0-9]+$`

Example extraction logic (using natural language understanding, not rigid parsing):
```markdown
# Read and comprehend milestone plan structure
# Look for patterns like:
# * **Task Sequence:**
#     1. **TASK-005:** Create `.claude/commands/task.md` command...
#     2. **TASK-006:** Implement task bundle directory creation...
#
# Extract: TASK-005, TASK-006 (in that order)
```

## Phase 2: Sequential Task Execution Using Existing Infrastructure

### 2.1 Initialize Milestone State Tracking
Create milestone bundle directory for state management:
```bash
milestone_bundle_dir=".milestone_bundles/${milestone_name}"
mkdir -p "$milestone_bundle_dir"

# Create milestone execution status with enhanced error handling fields
cat > "$milestone_bundle_dir/milestone_status.yaml" << EOF
milestone_name: ${milestone_name}
status: "executing"
started_at: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
milestone_plan_document: ${milestone_doc}
total_tasks: ${task_count}
current_task_index: 0
completed_tasks: []
failed_task: null
last_updated: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
execution_log: []
EOF

# Initialize tracking arrays for error handling
completed_tasks=()
current_index=0
```

### 2.2 Execute Tasks Sequentially Using Proven Infrastructure
For each identified TASK-XXX in order:

```bash
# Increment current task index for proper tracking
current_index=$((current_index + 1))

# Progress reporting before execution
echo "Starting ${task_id} [${current_index}/${total_tasks}]"

# Execute using existing /task infrastructure - DO NOT REINVENT
# Wait for each task to complete before starting the next
/task ${task_id}
task_exit_code=$?

# Handle execution result with comprehensive error handling
if [[ $task_exit_code -eq 0 ]]; then
    echo "Completed ${task_id} [${current_index}/${total_tasks}]"
    
    # Update milestone status with completed task
    completed_tasks+=("\"${task_id}\"")
    
    # Update milestone status atomically
    update_milestone_status_success "${milestone_bundle_dir}/milestone_status.yaml" "$task_id" "$current_index"
    
    # Continue to next task
else
    echo "FAILED: Task ${task_id} failed during milestone execution [${current_index}/${total_tasks}]"
    echo "The specific task that failed: ${task_id}"
    echo "Exit code: ${task_exit_code}"
    
    # Comprehensive error handling and context preservation
    handle_task_failure "$milestone_bundle_dir" "$task_id" "$current_index" "$total_tasks" "$task_exit_code"
    
    # STOP execution immediately - no subsequent tasks
    exit 1
fi
```

**CRITICAL**: Use existing `/task TASK-ID` command exactly as implemented in M2. Do not recreate task execution logic.

### 2.3 Progress Reporting Throughout Execution
Provide clear, consistent progress updates:

- **Task Start**: "Starting TASK-001 [1/5]"
- **Task Complete**: "Completed TASK-001 [1/5]" 
- **Task Skip**: "TASK-001 already completed, skipping..." (future enhancement)
- **Task Failure**: "FAILED: TASK-001 [1/5] - [specific error message]"
- **Milestone Complete**: "Milestone M1-Foundation completed successfully! [5/5 tasks]"

## Phase 3: Failure Handling & Recovery

### 3.1 Immediate Stop on Any Task Failure
When any task fails:
1. **Stop execution immediately** - do not attempt subsequent tasks
2. **Preserve all context** for debugging including:
   - Task bundle directory (`.task_bundles/TASK-XXX/`)
   - Milestone state (`.milestone_bundles/[milestone-name]/`)
   - Error output and exit codes
3. **Report failure clearly** - FAILED specific task that failed
4. **Update milestone status** to "failed" with failure details

### 3.2 Context Preservation for Debugging
```bash
# On failure, preserve state in milestone bundle
cat >> "$milestone_bundle_dir/failure_context.md" << EOF
# Milestone Execution Failure

**Failed Task**: ${failed_task_id}
**Task Position**: ${current_index}/${total_tasks}
**Failure Time**: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
**Error Details**: ${error_message}

## Debugging Information
- Task bundle: .task_bundles/${failed_task_id}/
- Milestone bundle: ${milestone_bundle_dir}/
- Task exit code: ${task_exit_code}

## Recovery Instructions
1. Review task bundle for specific failure details
2. Fix underlying issue in codebase or task blueprint
3. Re-run milestone from beginning: /milestone ${milestone_name}
EOF
```

### 3.3 No Subsequent Task Execution
Once any task fails, immediately exit the milestone execution. Do not attempt to execute remaining tasks, as they may depend on the failed task's completion.

## Security Requirements (Mandatory)

### Input Validation
```bash
# Validate milestone name (prevent injection attacks)
if [[ ! "$milestone_name" =~ ^[A-Za-z0-9-_]+$ ]]; then
    echo "Error: Invalid milestone name. Use only letters, numbers, hyphens, and underscores."
    exit 1
fi

# Enforce length limit
if [[ ${#milestone_name} -gt 50 ]]; then
    echo "Error: Milestone name too long (max 50 characters)."
    exit 1
fi
```

### Workspace Boundary Enforcement
```bash
# Validate all file operations remain within workspace
validate_workspace_path() {
    local path="$1"
    local workspace_root="$(pwd)"
    local canonical_path="$(realpath "$path" 2>/dev/null || echo "$path")"
    
    if [[ ! "$canonical_path" == "$workspace_root"* ]]; then
        echo "Error: Path outside workspace boundaries: $path"
        exit 1
    fi
}
```

### Safe Document Processing
- Use Read tool for all file operations
- Never execute content from milestone documents directly
- Validate extracted task identifiers before execution
- Handle missing or corrupted milestone documents gracefully

## Error Handling Patterns

### Clear Error Messages
```bash
# Document not found
echo "Error: Milestone plan not found for '$milestone_name'"
echo "Searched locations:"
echo "  - project_sdd_on_claude/"
echo "  - specs/milestones/"
echo "  - specs/"
echo ""
echo "Expected files like: *${milestone_name}*Milestone_Plan.md"

# Invalid task identifier
echo "Error: Invalid task identifier '$task_id' found in milestone plan"
echo "Expected format: TASK-[0-9]+"
echo "Document: $milestone_doc"

# Task execution failure
echo "Error: Task $task_id failed during milestone execution"
echo "Exit code: $task_exit_code" 
echo "Milestone execution stopped at task ${current_index}/${total_tasks}"
echo "Debug info: .task_bundles/$task_id/"
```

## Integration with Existing Infrastructure

### Task Command Integration
- Use `/task TASK-ID` exactly as implemented in M2
- Leverage existing task bundle system without modification
- Preserve all existing validation and quality requirements
- Maintain compatibility with existing specialist agents (Bundler, Coder, Validator)

### Hook System Integration (Future Enhancement)
- Prepare for integration with existing notification system
- Maintain compatibility with sound notifications from M2
- Structure for milestone-level progress notifications

### Resume Capability (Future Enhancement)
Design milestone state to support future resume functionality:
```yaml
# Structure milestone status for future resume logic
completed_tasks: ["TASK-005", "TASK-006"]  # Tasks that completed successfully
current_task_index: 2                       # Next task to execute
resume_supported: true                      # Flag for future enhancement
```

## Enhanced Error Handling Functions

### Error Handling and Context Preservation Functions
```bash
# Function to handle task failures with comprehensive error processing
handle_task_failure() {
    local milestone_bundle_dir="$1"
    local failed_task_id="$2" 
    local current_index="$3"
    local total_tasks="$4"
    local task_exit_code="$5"
    
    # Validate bundle directory path for security
    validate_workspace_path "$milestone_bundle_dir"
    
    # Get current timestamp for failure recording
    local failure_time=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    
    # Update milestone status to failed with comprehensive context
    update_milestone_status_failure "${milestone_bundle_dir}/milestone_status.yaml" "$failed_task_id" "$current_index" "$failure_time"
    
    # Create detailed failure context for debugging
    create_failure_context "$milestone_bundle_dir" "$failed_task_id" "$current_index" "$total_tasks" "$task_exit_code" "$failure_time"
    
    # Generate recovery guidance based on failure type
    generate_recovery_guidance "$milestone_bundle_dir" "$failed_task_id" "$task_exit_code"
    
    # Log execution state for visibility
    log_execution_state "$milestone_bundle_dir" "$failed_task_id" "$current_index" "$total_tasks"
}

# Function to update milestone status on success
update_milestone_status_success() {
    local status_file="$1"
    local completed_task="$2"
    local new_index="$3"
    
    # Validate inputs for security
    if [[ ! -f "$status_file" ]]; then
        echo "Error: Status file not found: $status_file"
        return 1
    fi
    
    # Validate workspace path for security
    validate_workspace_path "$status_file"
    
    # Read current status to preserve data with error handling
    local milestone_name=$(grep "^milestone_name:" "$status_file" 2>/dev/null | sed 's/milestone_name: //' | tr -d '"' || echo "unknown")
    local started_at=$(grep "^started_at:" "$status_file" 2>/dev/null | sed 's/started_at: //' | tr -d '"' || echo "unknown")
    local milestone_doc=$(grep "^milestone_plan_document:" "$status_file" 2>/dev/null | sed 's/milestone_plan_document: //' | tr -d '"' || echo "unknown")
    local total_tasks=$(grep "^total_tasks:" "$status_file" 2>/dev/null | sed 's/total_tasks: //' || echo "0")
    
    # Update status atomically with error handling
    if cat > "${status_file}.tmp" << EOF
milestone_name: "${milestone_name}"
status: "executing"
started_at: "${started_at}"
milestone_plan_document: "${milestone_doc}"
total_tasks: ${total_tasks}
current_task_index: ${new_index}
completed_tasks: [$(IFS=','; echo "${completed_tasks[*]}")] 
failed_task: null
last_updated: "$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")"
execution_log: []
EOF
    then
        mv "${status_file}.tmp" "$status_file"
    else
        echo "Error: Failed to update milestone status"
        rm -f "${status_file}.tmp" 2>/dev/null
        return 1
    fi
}

# Function to update milestone status on failure
update_milestone_status_failure() {
    local status_file="$1"
    local failed_task="$2"
    local current_index="$3"
    local failure_time="$4"
    
    # Validate inputs for security
    if [[ ! -f "$status_file" ]]; then
        echo "Error: Status file not found: $status_file"
        return 1
    fi
    
    # Validate workspace path for security
    validate_workspace_path "$status_file"
    
    # Read current status to preserve data with error handling
    local milestone_name=$(grep "^milestone_name:" "$status_file" 2>/dev/null | sed 's/milestone_name: //' | tr -d '"' || echo "unknown")
    local started_at=$(grep "^started_at:" "$status_file" 2>/dev/null | sed 's/started_at: //' | tr -d '"' || echo "unknown")
    local milestone_doc=$(grep "^milestone_plan_document:" "$status_file" 2>/dev/null | sed 's/milestone_plan_document: //' | tr -d '"' || echo "unknown")
    local total_tasks=$(grep "^total_tasks:" "$status_file" 2>/dev/null | sed 's/total_tasks: //' || echo "0")
    
    # Update status atomically with failure information and error handling
    if cat > "${status_file}.tmp" << EOF
milestone_name: "${milestone_name}"
status: "failed"
started_at: "${started_at}"
failed_at: "${failure_time}"
milestone_plan_document: "${milestone_doc}"
total_tasks: ${total_tasks}
current_task_index: ${current_index}
completed_tasks: [$(IFS=','; echo "${completed_tasks[*]}")] 
failed_task: "${failed_task}"
last_updated: "${failure_time}"
execution_log: []
EOF
    then
        mv "${status_file}.tmp" "$status_file"
    else
        echo "Error: Failed to update milestone status with failure information"
        rm -f "${status_file}.tmp" 2>/dev/null
        return 1
    fi
}

# Function to create detailed failure context for debugging
create_failure_context() {
    local milestone_bundle_dir="$1"
    local failed_task_id="$2"
    local current_index="$3"
    local total_tasks="$4"
    local task_exit_code="$5"
    local failure_time="$6"
    
    # Validate inputs for security
    if [[ ! -d "$milestone_bundle_dir" ]]; then
        echo "Error: Milestone bundle directory not found: $milestone_bundle_dir"
        return 1
    fi
    
    # Validate workspace path for security
    validate_workspace_path "$milestone_bundle_dir"
    
    # Sanitize error information following security patterns
    local safe_milestone_dir=$(basename "$milestone_bundle_dir" 2>/dev/null || echo "unknown")
    local safe_failed_task_id=$(echo "$failed_task_id" | sed 's/[^A-Za-z0-9-]//g')
    
    # Read milestone name safely for context
    local milestone_name="unknown"
    if [[ -f "$milestone_bundle_dir/milestone_status.yaml" ]]; then
        milestone_name=$(grep "^milestone_name:" "$milestone_bundle_dir/milestone_status.yaml" 2>/dev/null | sed 's/milestone_name: //' | tr -d '"' || echo "unknown")
    fi
    
    # Create comprehensive failure context with error handling
    if cat > "$milestone_bundle_dir/failure_context.md" << EOF
# Milestone Execution Failure

**Failed Task**: ${failed_task_id}
**Task Position**: ${current_index}/${total_tasks}
**Failure Time**: ${failure_time}
**Exit Code**: ${task_exit_code}

## Execution State Summary

### Completed Tasks
$(if [[ ${#completed_tasks[@]} -gt 0 ]]; then
    for task in "${completed_tasks[@]}"; do
        echo "- ${task//\"/}"
    done
else
    echo "- None"
fi)

### Failed Task Details
- **Task ID**: ${failed_task_id}
- **Position in Sequence**: Task ${current_index} of ${total_tasks}
- **Exit Code**: ${task_exit_code}

### Remaining Tasks
$(echo "Tasks ${current_index}/${total_tasks} through ${total_tasks}/${total_tasks} were not attempted due to failure")

## Debugging Information

### Task Bundle Location
- **Failed Task Bundle**: .task_bundles/${failed_task_id}/
- **Milestone Bundle**: ${safe_milestone_dir}/
- **Status Files**: milestone_status.yaml, failure_context.md

### Context Preservation
All task execution context has been preserved for debugging:
- Task bundle directory contains complete execution context
- Milestone state preserved for potential resume capability
- No automatic cleanup performed to maintain debugging information

## Recovery Instructions

### Immediate Next Steps
1. **Investigate the failure**:
   - Review task bundle: .task_bundles/${failed_task_id}/
   - Check bundle_status.yaml for specific failure details
   - Review validation results if available

2. **Identify root cause**:
   - Check if task blueprint needs clarification
   - Verify if codebase issues need resolution
   - Determine if architectural constraints were violated

3. **Choose recovery approach**:
   - **Fix and Retry**: Resolve underlying issue and re-run milestone
   - **Task Debugging**: Use /task ${failed_task_id} to debug specific task
   - **Milestone Review**: Review milestone plan for dependencies or sequencing issues

### Recovery Commands
\`\`\`bash
# To retry after fixing issues:
/milestone ${milestone_name//\"/}

# To debug the specific failed task:
/task ${failed_task_id}

# To review task details:
cat .task_bundles/${failed_task_id}/bundle_status.yaml
\`\`\`

### Important Notes
- **No Partial Completion**: Milestone execution stops completely on any task failure
- **State Preservation**: All context preserved for debugging and potential resume
- **Sequential Dependency**: Later tasks may depend on earlier task completion
- **Full Restart**: Current implementation requires full milestone restart after fixes
EOF
    then
        echo "Failure context created successfully: $milestone_bundle_dir/failure_context.md"
    else
        echo "Error: Failed to create failure context file"
        return 1
    fi
}

# Function to generate tailored recovery guidance
generate_recovery_guidance() {
    local milestone_bundle_dir="$1"
    local failed_task_id="$2"
    local task_exit_code="$3"
    
    # Validate inputs for security
    if [[ ! -d "$milestone_bundle_dir" ]]; then
        echo "Error: Milestone bundle directory not found: $milestone_bundle_dir"
        return 1
    fi
    
    # Validate workspace path for security
    validate_workspace_path "$milestone_bundle_dir"
    
    # Sanitize task ID for security
    local safe_failed_task_id=$(echo "$failed_task_id" | sed 's/[^A-Za-z0-9-]//g')
    
    # Generate guidance based on exit code patterns
    local guidance_type="general"
    local specific_guidance=""
    
    case $task_exit_code in
        1)
            guidance_type="validation_failure"
            specific_guidance="Task likely failed during validation phase. Check validation results and code quality."
            ;;
        2)
            guidance_type="compilation_failure"
            specific_guidance="Task likely failed during compilation or build. Check syntax and dependencies."
            ;;
        126)
            guidance_type="permission_failure"
            specific_guidance="Permission denied. Check file permissions and workspace access."
            ;;
        127)
            guidance_type="command_not_found"
            specific_guidance="Command or tool not found. Verify task dependencies and tool availability."
            ;;
        *)
            guidance_type="general"
            specific_guidance="General task failure. Review task bundle for specific error details."
            ;;
    esac
    
    # Append specific guidance to failure context with error handling
    if [[ -f "$milestone_bundle_dir/failure_context.md" ]]; then
        if cat >> "$milestone_bundle_dir/failure_context.md" << EOF

## Failure Analysis

**Exit Code**: ${task_exit_code}
**Failure Type**: ${guidance_type}
**Specific Guidance**: ${specific_guidance}

### Recommended Investigation Steps
1. Check task bundle status: .task_bundles/${safe_failed_task_id}/bundle_status.yaml
2. Review any validation results or error logs in task bundle
3. Verify task blueprint clarity and completeness
4. Check for dependency issues or missing prerequisites
EOF
        then
            echo "Recovery guidance appended successfully"
        else
            echo "Error: Failed to append recovery guidance"
            return 1
        fi
    else
        echo "Error: Failure context file not found for recovery guidance"
        return 1
    fi
}

# Function to log execution state for visibility
log_execution_state() {
    local milestone_bundle_dir="$1"
    local failed_task_id="$2"
    local current_index="$3"
    local total_tasks="$4"
    
    # Validate inputs for security
    if [[ ! -d "$milestone_bundle_dir" ]]; then
        echo "Error: Milestone bundle directory not found: $milestone_bundle_dir"
        return 1
    fi
    
    # Validate workspace path for security
    validate_workspace_path "$milestone_bundle_dir"
    
    # Sanitize task ID for security
    local safe_failed_task_id=$(echo "$failed_task_id" | sed 's/[^A-Za-z0-9-]//g')
    
    # Get start time safely
    local start_time="unknown"
    if [[ -f "$milestone_bundle_dir/milestone_status.yaml" ]]; then
        start_time=$(grep "^started_at:" "$milestone_bundle_dir/milestone_status.yaml" 2>/dev/null | sed 's/started_at: //' | tr -d '"' || echo "unknown")
    fi
    
    # Create execution log for detailed tracking with error handling
    if cat > "$milestone_bundle_dir/execution_log.txt" << EOF
Milestone Execution Log
======================

Execution Summary:
- Started: ${start_time}
- Failed: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
- Progress: ${current_index}/${total_tasks} tasks attempted

Completed Tasks (${#completed_tasks[@]}):
$(if [[ ${#completed_tasks[@]} -gt 0 ]]; then
    for i in "${!completed_tasks[@]}"; do
        echo "$((i+1)). ${completed_tasks[i]//\"/} - COMPLETED"
    done
else
    echo "None"
fi)

Failed Task:
${current_index}. ${safe_failed_task_id} - FAILED

Remaining Tasks (not attempted):
$(echo "Tasks $((current_index+1)) through ${total_tasks} were not attempted due to failure")

EOF
    then
        echo "Execution log created successfully: $milestone_bundle_dir/execution_log.txt"
    else
        echo "Error: Failed to create execution log"
        return 1
    fi
}
```

## Success Criteria Validation

This command succeeds when ALL of the following work correctly:
1. **Document Comprehension**: Reads any milestone plan and extracts task sequences correctly
2. **Sequential Execution**: Uses existing `/task` infrastructure to execute each task in order
3. **Progress Reporting**: Provides clear status updates throughout execution
4. **Failure Handling**: Stops immediately on failure with preserved context for debugging
5. **Security Compliance**: Validates all inputs and enforces workspace boundaries
6. **Infrastructure Integration**: Works seamlessly with existing M2 task execution system

## Remember

You are the milestone orchestrator, not the task implementer:
1. **Understand milestone plans** through natural language comprehension
2. **Execute tasks sequentially** using proven `/task` infrastructure  
3. **Report progress clearly** throughout the process
4. **Handle failures gracefully** with immediate stop and context preservation
5. **Maintain security** through input validation and workspace boundaries

Trust the existing infrastructure. Your job is orchestration, not reimplementation.