---
name: bundle_task_temp
description: "Create task bundle using the SDD bundling workflow (extracted from /task command)"
argument-hint: "TASK-XXX"
allowed-tools: ["Read", "Write", "LS", "Bash", "Task"]
---

# Bundle Task Command - SDD Bundling Workflow

Create a task bundle using the SDD bundling workflow extracted from the main `/task` command. This command handles Phase 1 (Bundle Creation) and Phase 2 (Bundler Agent Invocation) of the SDD assembly line.

## Bundling Process

### Phase 1: Input Validation & Bundle Creation

1. **Validate Task ID**: Ensure task ID matches pattern `TASK-\d+` (e.g., TASK-006, TASK-1234)
   - Reject invalid formats with clear error message
   - Check that task blueprint exists in `project_sdd_on_claude/tasks/TASK-XXX_*.md`

2. **Create Task Bundle**: Create bundle directory structure
   - Create `.task_bundles/TASK-XXX/` directory 
   - Copy task blueprint to bundle directory as `task_blueprint.md`
   - Create initial `bundle_status.yaml` with status: "created"
   - Context files (`bundle_*.md`) will be created by Bundler Agent

3. **Handle Conflicts**: If bundle directory already exists
   - Preserve existing bundle with timestamp suffix
   - Create new bundle for current execution
   - Report preservation to user

### Phase 2: Bundler Agent Invocation

1. **Invoke Bundler Agent**: Use Task tool with "bundler-specialist" subagent
   - Provide complete task context and bundle path
   - Request creation of context files: `bundle_architecture.md`, `bundle_security.md`, `bundle_code_context.md`, `bundle_dependencies.md`
   - Update bundle status to "bundling"

2. **Validate Bundle Context**: Verify Bundler Agent completed successfully
   - Confirm required context files were created
   - Update bundle status to "ready_for_coding"

## Security & Quality Standards

**Input Validation:**
- Validate task ID format using secure regex patterns
- Prevent path traversal attacks in all file operations
- Sanitize all user inputs before processing

**Bundle Management:**
- Use atomic operations where possible
- Maintain consistent filesystem state
- Provide clear error messages and recovery guidance

**Agent Coordination:**
- Ensure clean context isolation for Bundler Agent
- Pass only necessary, sanitized information to sub-agent
- Maintain bundle status throughout workflow

## Success Criteria

The command succeeds when:
1. Task bundle is created with correct structure and status tracking
2. Bundler Agent completes successfully and creates all required context files
3. Bundle status is updated to "ready_for_coding"
4. User receives clear confirmation of bundle creation

## Error Handling

**Common Failure Modes:**
- Invalid task ID format → Clear format requirements
- Missing task blueprint → Guide user to check task files
- Bundler Agent invocation failure → Preserve bundle state and provide debugging info

Report all errors clearly with actionable next steps for the user.

## Task ID

Process the task: **{argument}**

Start by validating the task ID, creating the bundle structure, and invoking the bundler-specialist.