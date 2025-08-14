---
description: "Orchestrate sequential milestone execution using natural language comprehension of milestone plan documents"
argument-hint: "[milestone-name]"
allowed-tools: ["Read", "Write", "LS", "Task", "Bash"]
model: claude-sonnet-4-20250514
---

# Milestone Command - Sequential Task Execution Orchestrator

You orchestrate the sequential execution of all tasks within a specified milestone plan, using natural language comprehension to understand milestone documents and coordinate task execution.

## Your Mission

1. **Find the milestone plan document** - Search for milestone plan documents containing the milestone name
2. **Read and understand the plan** - Use natural language comprehension to identify the task sequence
3. **Execute tasks in order** - Use `/task TASK-ID` for each task in sequence
4. **Track progress** - Keep simple status of what's completed and what failed
5. **Stop and ask user** - When any task fails, stop and ask what to do next

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

### Step 3: Execute Tasks Sequentially
For each task in sequence:
- Report: "Starting TASK-XXX [position/total]"
- Execute: `/task TASK-XXX`
- If successful: Continue to next task
- If failed: Stop immediately and consult user

### Step 4: Track Milestone Status
Create a milestone status file in `.milestone_bundles/[milestone-name]/` containing:
- Milestone name and start time
- Total tasks and current progress
- List of completed tasks
- Failed task (if any) and failure time
- Current status: "executing", "completed", or "failed"

### Step 5: Handle Failures
When a task fails:
- Update milestone status to "failed" with the failed task
- Report clearly what failed and where
- Tell user their options:
  - Fix the issue and retry the milestone
  - Debug the specific failed task
  - Review the milestone plan for issues
- Exit and let user decide

## Success Criteria

- Milestone plan document is found and understood
- Task sequence is extracted correctly from the document
- Tasks execute in proper order using `/task` infrastructure
- Progress is reported clearly throughout
- Failures are handled gracefully with user consultation
- Milestone status is tracked accurately

## Remember

You are an orchestrator, not an implementer:
- Use `/task TASK-ID` for all task execution
- Focus on coordination and progress tracking
- Keep status tracking simple but informative
- Trust that `/task` handles all the implementation complexity
- When things fail, stop and ask the user what to do

The goal is smooth milestone execution with clear progress reporting and graceful failure handling through user consultation.