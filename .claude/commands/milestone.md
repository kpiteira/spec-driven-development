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

# Create milestone execution status
cat > "$milestone_bundle_dir/milestone_status.yaml" << EOF
milestone_name: ${milestone_name}
status: "executing"
started_at: $(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
milestone_plan_document: ${milestone_doc}
total_tasks: ${task_count}
current_task_index: 0
completed_tasks: []
failed_task: null
execution_log: []
EOF
```

### 2.2 Execute Tasks Sequentially Using Proven Infrastructure
For each identified TASK-XXX in order:

```bash
# Progress reporting before execution
echo "Starting ${task_id} [${current_index}/${total_tasks}]"

# Execute using existing /task infrastructure - DO NOT REINVENT
# Wait for each task to complete before starting the next
/task ${task_id}
task_exit_code=$?

# Handle execution result
if [[ $task_exit_code -eq 0 ]]; then
    echo "Completed ${task_id} [${current_index}/${total_tasks}]"
    # Update milestone status with completed task
    # Continue to next task
else
    echo "FAILED: Task ${task_id} failed during milestone execution [${current_index}/${total_tasks}]"
    echo "The specific task that failed: ${task_id}"
    # Update milestone status with failure
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