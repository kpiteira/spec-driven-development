---
description: "Initialize task bundle and prepare for SDD assembly line execution"
argument-hint: "TASK-XXX"
allowed-tools: ["Read", "Write", "LS", "Bash"]
---

# Task Command - SDD Assembly Line Entry Point

Execute the SDD assembly line workflow for a specified task. This command creates task bundles and coordinates the Bundler → Coder → Validator workflow with proper context isolation and state management.

## Task Execution Process

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
   - Request creation of context files: `bundle_architecture.md`, `bundle_security.md`, `bundle_code_context.md`
   - Update bundle status to "bundling"

2. **Validate Bundle Context**: Verify Bundler Agent completed successfully
   - Confirm required context files were created
   - Update bundle status to "ready_for_coding"

### Phase 3: Coder Agent Invocation  

1. **Invoke Coder Agent**: Use Task tool with "coder-specialist" subagent
   - Provide bundle path and context files
   - Request TDD implementation following task blueprint contract
   - Update bundle status to "coding"

2. **Validate Implementation**: Confirm Coder Agent completed successfully
   - Update bundle status to "ready_for_validation"

### Phase 4: Validator Agent Invocation

1. **Invoke Validator Agent**: Use Task tool with "validator-specialist" subagent
   - Provide bundle path and implementation locations
   - Request comprehensive validation per task blueprint verification requirements
   - Update bundle status to "validating"

2. **Process Results**: Handle validation outcomes
   - **Success**: Update status to "completed", clean up bundle directory
   - **Failure**: Update status to "failed", preserve bundle for debugging

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
- Ensure clean context isolation between agents
- Pass only necessary, sanitized information to sub-agents
- Maintain bundle status throughout workflow

## Success Criteria

The command succeeds when:
1. Task bundle is created with correct structure and status tracking
2. All three agents (Bundler, Coder, Validator) complete successfully
3. Implementation passes all validation requirements
4. Bundle is properly cleaned up (success) or preserved (failure)
5. User receives clear confirmation of completion or actionable error messages

## Error Handling

**Common Failure Modes:**
- Invalid task ID format → Clear format requirements
- Missing task blueprint → Guide user to check task files
- Agent invocation failure → Preserve bundle state and provide debugging info
- Validation failure → Preserve implementation and bundle for analysis

Report all errors clearly with actionable next steps for the user.