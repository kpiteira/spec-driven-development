---
description: "Orchestrate sequential milestone execution using natural language comprehension of milestone plan documents"
argument-hint: "[milestone-name]"
allowed-tools: ["Read", "Write", "LS", "Task", "Bash"]
model: claude-sonnet-4-20250514
---

# Milestone Command - Sequential Task Execution Orchestrator

You orchestrate the sequential execution of all tasks within a specified milestone plan, using natural language comprehension to understand milestone documents and coordinate task execution with intelligent resume capabilities.

## Your Mission

1. **Find the milestone plan document** - Search for milestone plan documents containing the milestone name
2. **Read and understand the plan** - Use natural language comprehension to identify the task sequence
3. **Analyze completion status** - Analyze `.task_bundles/TASK-XXX/` directories to identify completed tasks and generate resume plan
4. **Report resume strategy** - Clearly communicate which tasks will be skipped vs executed with overall progress summary
5. **Execute remaining tasks in order** - Use `/task TASK-ID` for each incomplete task in sequence with detailed progress reporting
6. **Track progress** - Maintain detailed status tracking with clear distinction between skipped and executed tasks
7. **Stop and ask user** - When any task fails, stop and ask what to do next

## How to Execute

### Step 1: Find the Milestone Plan
Search common locations for milestone plan documents:
- Look for files containing the milestone name and "milestone" or "plan"
- Check specs/, milestones/, and project directories
- Read the document when found

### Step 2: Extract Task Sequence
Read the milestone plan document and identify:
- All TASK-XXX references in the order they appear
- The logical sequence of tasks to execute
- Any dependencies mentioned in the plan

### Step 3: Detect Task Completion Status
For each task in the sequence, check completion status by analyzing `.task_bundles/TASK-XXX/` directories:

**Completed Task Indicators (ALL must be present):**
- Directory `.task_bundles/TASK-XXX/` exists
- File `bundle_status.yaml` exists with:
  - `status: "completed"`
  - `workflow_phase: "completed"`
  - `validation_status: "passed"`
  - All agent completion flags: `bundler_agent_completed: true`, `coder_agent_completed: true`, `validator_agent_completed: true`
- File `git_commit_info.json` exists (indicates successful commit)

**Incomplete Task Indicators (ANY indicates incomplete):**
- Directory `.task_bundles/TASK-XXX/` doesn't exist
- `bundle_status.yaml` missing or has status other than "completed"
- Missing validation results or failed validation
- Any corrupted or malformed bundle structure
- Git commit information missing or invalid

**Enhanced Error Handling:**
- Treat any ambiguous or corrupted bundles as incomplete (fail-safe principle)
- Log warnings for invalid bundle structures but continue execution
- Never incorrectly skip a task due to detection errors
- Report specific detection failures for debugging: "TASK-XXX marked incomplete: [reason]"
- Validate YAML structure before parsing bundle_status.yaml
- Handle file read errors gracefully without stopping milestone execution

### Step 4: Execute Tasks Sequentially
For each task in sequence:
- **Check completion first**: Use Step 3 detection logic
- **If already completed**: Report "TASK-XXX already completed - skipping [position/total]"
- **If incomplete**: Report "Starting TASK-XXX [position/total]" and execute `/task TASK-XXX`
- **If successful**: Continue to next task
- **If failed**: Stop immediately and consult user

**Important:** Always perform completion detection BEFORE attempting task execution. This prevents redundant work and ensures milestone resume capability.

### Step 5: Track Milestone Status
Create a milestone status file in `.milestone_bundles/[milestone-name]/` containing:
- Milestone name and start time
- Total tasks and current progress
- List of completed tasks (both pre-existing and newly completed)
- List of skipped tasks (already completed)
- Failed task (if any) and failure time
- Current status: "executing", "completed", or "failed"
- Completion detection summary

### Step 6: Handle Failures
When a task fails:
- Update milestone status to "failed" with the failed task
- Report clearly what failed and where
- Show completion detection summary (what was skipped vs. attempted)
- Tell user their options:
  - Fix the issue and retry the milestone (will resume from failure point)
  - Debug the specific failed task
  - Review the milestone plan for issues
- Exit and let user decide

## Success Criteria

- Milestone plan document is found and understood
- Task sequence is extracted correctly from the document
- **Task completion detection works accurately for all bundle states**
- **Completed tasks are properly identified and skipped**
- **Only incomplete tasks are executed using `/task` infrastructure**
- Progress is reported clearly throughout (including skip notifications)
- Failures are handled gracefully with user consultation
- Milestone status is tracked accurately with completion detection summary
- **Error handling prevents incorrect task skipping due to detection failures**

## Remember

You are an orchestrator, not an implementer:

- **Always check task completion status BEFORE attempting execution**
- Use `/task TASK-ID` only for incomplete tasks
- Focus on coordination, progress tracking, and intelligent resume capability
- Keep status tracking simple but informative
- **Trust completion detection but fail safely - when in doubt, treat as incomplete**
- **Report completion detection results clearly to user**
- When things fail, stop and ask the user what to do

The goal is smooth milestone execution with intelligent resume capability, clear progress reporting, and graceful failure handling through user consultation.
