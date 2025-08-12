---
description: "Execute milestone plan with sequential task execution using natural language comprehension"
argument-hint: "[milestone-name]"
allowed-tools: ["Read", "Write", "LS", "Bash", "Task"]
---

# Milestone Command - Sequential Task Execution

Execute milestone plans through automated task sequence execution. This command enables Claude Code agents to read and understand any milestone plan document, then orchestrate sequential task execution using existing `/task` command infrastructure from M2.

## Milestone Execution Process

### Phase 1: Input Validation & Milestone Plan Discovery

1. **Validate Milestone Name (Security Critical)**
   - Use strict regex validation: `^[A-Za-z0-9][A-Za-z0-9_-]*$`
   - Reject milestone names with path traversal sequences (../../../etc/passwd)
   - Enforce length limits: 1-50 characters
   - Exit immediately on validation failure with clear error message

2. **Discover and Validate Milestone Plan Document**
   - Search for milestone plan files in `project_sdd_on_claude/` directory
   - Pattern: `[NUMBER]_[MILESTONE-NAME]_Milestone_Plan.md`
   - Validate file exists and is accessible
   - Ensure path remains within project boundaries using absolute path validation
   - Reject any paths attempting to escape project workspace

3. **Read Milestone Plan Document**
   - Use Read tool to load milestone plan content
   - Validate document structure and format
   - Apply natural language comprehension to understand document sections
   - Identify Implementation Plan sections for task sequence extraction

### Phase 2: Task Sequence Extraction Using Natural Language Comprehension

1. **Apply Natural Language Understanding to Document Content**
   - Read and comprehend milestone plan document structure
   - Identify "Implementation Plan" and "Task Sequence" sections
   - Extract TASK-XXX identifiers through document analysis, not regex parsing
   - Understand task ordering based on document sequence and context
   - Filter tasks to those appearing in actual implementation sequences

2. **Validate Extracted Task Identifiers**
   - Validate each TASK-XXX identifier using strict pattern: `^TASK-[0-9]+$`
   - Reject task IDs with shell command sequences or path components
   - Verify task blueprints exist in `project_sdd_on_claude/tasks/TASK-XXX_*.md`
   - Build validated task sequence list in execution order

### Phase 3: Sequential Task Execution

1. **Initialize Milestone State Tracking**
   - Create milestone state directory: `.milestone_bundles/[MILESTONE-NAME]/`
   - Generate `milestone_status.yaml` with initial state:
     - milestone_id: extracted from milestone plan
     - milestone_name: user-provided argument
     - status: "running"
     - current_task: first task in sequence
     - current_task_index: 0
     - total_tasks: count of tasks in sequence
     - completed_tasks: [] (empty initially)
     - failed_task: null
     - task_sequence: array of TASK-XXX identifiers
     - milestone_plan_path: path to milestone plan document
     - execution_started_at: ISO 8601 UTC timestamp
     - last_updated: ISO 8601 UTC timestamp

2. **Execute Tasks Sequentially Using Existing /task Infrastructure**
   - For each task in validated sequence:
     - Report progress: "Starting [TASK-ID] [N/Total]"
     - Execute using existing `/task [TASK-ID]` command from M2
     - Wait for task completion before proceeding to next task
     - Validate task completion by checking `.task_bundles/[TASK-ID]/bundle_status.yaml`
     - Update milestone status with current progress
     - On success: Report completion: "Completed [TASK-ID] [N/Total]"
     - On failure: Stop immediately and preserve all context

3. **Progress Reporting During Execution**
   - Provide clear progress updates following format standards:
     - Start: "Starting TASK-XXX [N/Total]"
     - Complete: "Completed TASK-XXX [N/Total]" 
   - Update milestone state file with current progress
   - Maintain accurate task counts and completion tracking
   - Preserve execution context for debugging and recovery

### Phase 4: Failure Handling with Immediate Stop

1. **Detect Task Execution Failures**
   - Monitor task execution status through task bundle validation
   - Check `.task_bundles/[TASK-ID]/bundle_status.yaml` for failure states
   - Detect task command execution errors or timeout conditions
   - Identify specific failure phase and error details

2. **Immediate Stop on Any Task Failure**
   - Stop milestone execution immediately when any task fails
   - Do not attempt subsequent tasks after failure
   - Preserve all task bundle context for debugging
   - Update milestone status to "failed" with failure details
   - Record failed task identifier and failure timestamp

3. **Comprehensive Error Reporting**
   - Report which specific task failed with clear identification
   - Include failure phase information (bundling, coding, validation)
   - Preserve task bundle directory path for debugging
   - Provide actionable guidance for failure investigation
   - Log error context without exposing sensitive information

4. **Context Preservation for Recovery**
   - Maintain milestone state file with failure information
   - Preserve all task bundle artifacts for analysis
   - Record execution progress up to failure point
   - Enable manual recovery and continuation workflows
   - Provide clear recovery instructions and next steps

## Security & Quality Standards

**Input Validation:**
- Validate milestone name format using secure regex patterns
- Prevent path traversal attacks in all file operations
- Sanitize milestone plan content analysis
- Validate task identifiers before execution

**File System Security:**
- All file operations remain within project workspace boundaries
- Use absolute path validation to prevent directory traversal
- Validate milestone plan document paths against project structure
- Ensure state file operations use appropriate permissions

**Task Execution Security:**
- Pass only validated TASK-XXX identifiers to existing `/task` command
- Never bypass existing task command security validation
- Preserve security context throughout milestone execution workflow
- Use established task execution isolation patterns

**State Management Security:**
- Create milestone state files with restricted permissions (600)
- Use atomic file operations for state updates where possible
- Validate state file integrity before reading
- Preserve state files for security audit trail

## Success Criteria

The milestone command succeeds when:

1. Milestone name passes security validation and milestone plan is discovered
2. Task sequence is successfully extracted through natural language comprehension
3. All tasks execute successfully in sequential order using existing `/task` infrastructure
4. Progress reporting provides clear visibility throughout execution
5. Milestone completes with all tasks validated and committed to git repository
6. Milestone state is preserved with complete execution artifacts for review

## Error Handling

**Input Validation Failures:**
- **Invalid milestone name format** → Validate using regex `^[A-Za-z0-9][A-Za-z0-9_-]*$`, reject security risks
- **Milestone plan not found** → Search `project_sdd_on_claude/*_[NAME]_Milestone_Plan.md`, report missing file
- **Path traversal attempts** → Reject immediately with security error message

**Document Reading Failures:**
- **Milestone plan read errors** → Validate file permissions and accessibility
- **Document format errors** → Check milestone plan structure and content validity
- **Task sequence extraction failures** → Verify Implementation Plan sections exist

**Task Execution Failures:**
- **Task command execution errors** → Log task-specific error details to milestone state
- **Task validation failures** → Preserve task bundle context, stop milestone execution
- **Task timeout conditions** → Update milestone status to "failed", report timeout details

**State Management Failures:**
- **State file creation errors** → Validate directory permissions and disk space
- **State update failures** → Use atomic operations, preserve previous state on error
- **Recovery state corruption** → Maintain backup state for critical transitions

**Security Error Handling:**
- **Path traversal attempts** → Log security violation, stop execution immediately
- **Milestone plan content exploitation** → Sanitize document analysis, reject malicious content
- **Task ID injection attempts** → Validate against whitelist, report security violation

**Error Recovery Patterns:**
- **Preserve milestone state on all failures** → Never delete failed milestone context
- **Atomic state updates** → Use temporary files for state updates, move atomically
- **Detailed error logging** → Write error details to milestone directory for troubleshooting
- **Actionable guidance** → Provide specific next steps for each failure mode

**Milestone Status Error States:**
- "failed" → Task execution failed or security violation detected
- "validation_failed" → Task validation errors during execution
- "security_failed" → Security validation errors or policy violations
- "error_recovery" → General error state requiring manual inspection

**Milestone Status Success States:**
- "completed" → All tasks completed successfully with full validation
- "running" → Milestone execution in progress with current task tracking